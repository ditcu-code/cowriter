//
//  TestStoreKit.swift
//  cowriter
//
//  Created by Aditya Cahyo on 09/05/23.
//

import SwiftUI
import StoreKit

struct TestStoreKit: View {
    @EnvironmentObject
    private var purchaseManager: PurchaseManager

    var body: some View {
        VStack(spacing: 20) {
            if purchaseManager.hasUnlockedPro {
                Text("Thank you for purchasing pro!")
            } else {
                Text("Products")
                ForEach(purchaseManager.products) { product in
                    Button {
                        _ = Task<Void, Never> {
                            do {
                                try await purchaseManager.purchase(product)
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("\(product.displayPrice) - \(product.displayName)")
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .clipShape(Capsule())
                    }
                }

                Button {
                    _ = Task<Void, Never> {
                        do {
                            try await AppStore.sync()
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Restore Purchases")
                }
            }
        }.task {
            _ = Task<Void, Never> {
                do {
                    try await purchaseManager.loadProducts()
                } catch {
                    print(error)
                }
            }
        }
    }
}
