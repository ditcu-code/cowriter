//
//  RevenueCatService.swift
//  cowriter
//
//  Migrates purchase flow from StoreKit 2 to RevenueCat.
//

import Combine
import Foundation
import RevenueCat

struct PaywallPackage: Identifiable, Equatable {
	// Product identifier (e.g., "cowriter.pro.monthly.v1")
	let id: String
	// Localized price string (e.g., "$5.99")
	let displayPrice: String
	// Raw price for calculations (e.g., annual / 12)
	let price: Decimal
	// Currency code for formatting derived values
	let currencyCode: String?

	var plan: PlanEnum? { PlanEnum(rawValue: id) }
}

final class RevenueCatService: NSObject, ObservableObject {
    @Published private(set) var packages: [PaywallPackage] = []
    @Published private(set) var isLoading: Bool = false

    private let entitlementManager: EntitlementManager
    private var isConfigured = false

    init(entitlementManager: EntitlementManager) {
        self.entitlementManager = entitlementManager
        super.init()
        // Attempt early configuration to avoid using Purchases before configure
        configureIfPossible()
    }

	// MARK: - Public API

    func configureIfPossible() {
        guard
            let apiKey = Bundle.main.object(
                forInfoDictionaryKey: "REVENUECAT_API_KEY"
            ) as? String,
            !apiKey.isEmpty,
            apiKey != "rc_ios_api_key_placeholder"
        else { return }
        if !isConfigured {
            configure(withAPIKey: apiKey)
        }
    }

	func loadOfferings() {
		loadOfferingsImpl()
	}

	func purchasePackage(
		_ pkg: PaywallPackage,
		completion: ((Bool) -> Void)? = nil
	) {
		purchaseImpl(productId: pkg.id, completion: completion)
	}

	func restorePurchases(completion: ((Bool) -> Void)? = nil) {
		restoreImpl(completion: completion)
	}

	func refreshCustomerInfo() {
		refreshCustomerInfoImpl()
	}

	// MARK: - Impl (RevenueCat / stubs)

	private var packageByProductId: [String: Package] = [:]

    private func configure(withAPIKey apiKey: String) {
        Purchases.logLevel = .info
        Purchases.configure(withAPIKey: apiKey)
        Purchases.shared.delegate = self
        isConfigured = true
        refreshCustomerInfoImpl()
        // Link existing subscribers’ receipts to the RC user on first launch after migration
        Purchases.shared.syncPurchases { [weak self] info, error in
            if let error = error {
                print("[RC] syncPurchases error: \(error)")
            }
            self?.updateEntitlements(from: info)
        }
    }

    private func loadOfferingsImpl() {
        guard isConfigured else { return }
        DispatchQueue.main.async { [weak self] in self?.isLoading = true }
        Purchases.shared.getOfferings { [weak self] offerings, error in
            guard let self = self else { return }
            DispatchQueue.main.async { self.isLoading = false }
            if let error = error {
                print("[RC] getOfferings error: \(error)")
                return
            }
            guard let available = offerings?.current?.availablePackages
            else {
                DispatchQueue.main.async { self.packages = [] }
                self.packageByProductId = [:]
                return
            }

			// Filter to known plans and map to PaywallPackage
			let knownIds = Set(PlanEnum.allCases.map { $0.rawValue })
			let filtered = available.filter {
				knownIds.contains($0.storeProduct.productIdentifier)
			}

            self.packageByProductId = Dictionary(
                uniqueKeysWithValues: filtered.map {
                    ($0.storeProduct.productIdentifier, $0)
                }
            )

			let mapped: [PaywallPackage] = filtered.map { pkg in
				let sp = pkg.storeProduct
				let formatter = sp.priceFormatter
				let priceString =
					formatter?.string(
						from: NSDecimalNumber(decimal: sp.price)
					) ?? ""
				let currency = sp.currencyCode ?? formatter?.currencyCode
				return PaywallPackage(
					id: sp.productIdentifier,
					displayPrice: priceString,
					price: sp.price,
					currencyCode: currency
				)
			}

			// Sort by PlanEnum order
			let order = PlanEnum.allCases.map { $0.rawValue }
            let sorted = mapped.sorted { lhs, rhs in
                (order.firstIndex(of: lhs.id) ?? 0)
                    < (order.firstIndex(of: rhs.id) ?? 0)
            }
            DispatchQueue.main.async { self.packages = sorted }
        }
    }

    private func purchaseImpl(
        productId: String,
        completion: ((Bool) -> Void)?
    ) {
        guard isConfigured else { completion?(false); return }
        guard let pkg = packageByProductId[productId] else {
            completion?(false)
            return
        }
        Purchases.shared.purchase(package: pkg) {
            [weak self] _, customerInfo, error, userCancelled in
            if let error = error { print("[RC] purchase error: \(error)") }
            self?.updateEntitlements(from: customerInfo)
            // Optimistic UI update: if a known product was purchased successfully, flip hasPro immediately
            if userCancelled == false && error == nil {
                let known = Set(PlanEnum.allCases.map { $0.rawValue })
                if known.contains(productId) {
                    DispatchQueue.main.async { self?.entitlementManager.hasPro = true }
                }
            }
            completion?(userCancelled == false && error == nil)
        }
    }

    private func restoreImpl(completion: ((Bool) -> Void)?) {
        guard isConfigured else { completion?(false); return }
        Purchases.shared.restorePurchases {
            [weak self] customerInfo, error in
            if let error = error { print("[RC] restore error: \(error)") }
            self?.updateEntitlements(from: customerInfo)
            completion?(error == nil)
        }
    }

    private func refreshCustomerInfoImpl() {
        guard isConfigured else { return }
        Purchases.shared.getCustomerInfo { [weak self] info, error in
            if let error = error {
                print("[RC] getCustomerInfo error: \(error)")
            }
            self?.updateEntitlements(from: info)
        }
    }

    private func updateEntitlements(from info: CustomerInfo?) {
        guard let info = info else { return }
        // Primary: use entitlement mapping named "pro"
        var isPro = info.entitlements.all["pro"]?.isActive == true
        // Fallback: infer from active product identifiers in case entitlement mapping is missing/misnamed
        if !isPro {
            let active = Set(info.activeSubscriptions)
            let known = Set(PlanEnum.allCases.map { $0.rawValue })
            isPro = !active.intersection(known).isEmpty
        }
        DispatchQueue.main.async { [weak self] in
            self?.entitlementManager.hasPro = isPro
        }
    }

}

extension RevenueCatService: PurchasesDelegate {
	func purchases(
		_ purchases: Purchases,
		receivedUpdated customerInfo: CustomerInfo
	) {
		updateEntitlements(from: customerInfo)
	}
}

// Allow capturing `self` in `@Sendable` SDK closures.
// This service is used on the main thread and posts updates to the main queue.
extension RevenueCatService: @unchecked Sendable {}
