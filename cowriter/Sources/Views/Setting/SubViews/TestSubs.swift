//
//  TestSubs.swift
//  cowriter
//
//  Created by Aditya Cahyo on 09/05/23.
//

import SwiftUI

struct TestSubs: View {
    @StateObject private var entitlementManager: EntitlementManager
    @StateObject private var purchaseManager: PurchaseManager
    
    init() {
        let entitlementManager = EntitlementManager()
        let purchaseManager = PurchaseManager(entitlementManager: entitlementManager)
        self._entitlementManager = StateObject(wrappedValue: entitlementManager)
        self._purchaseManager = StateObject(wrappedValue: purchaseManager)
    }
    
    var body: some View {
        TestStoreKit()
            .environmentObject(entitlementManager)
            .environmentObject(purchaseManager)
            .task {
                await purchaseManager.updatePurchasedProducts()
            }
    }
}

struct TestSubs_Previews: PreviewProvider {
    static var previews: some View {
        TestSubs()
    }
}

