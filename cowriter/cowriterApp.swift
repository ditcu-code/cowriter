//
//  cowriterApp.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/04/23.
//

import SwiftUI

@main
struct cowriterApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var entitlementManager: EntitlementManager
    @StateObject private var purchaseManager: PurchaseManager
    
    init() {
        let entitlementManager = EntitlementManager()
        let purchaseManager = PurchaseManager(entitlementManager: entitlementManager)
        self._entitlementManager = StateObject(wrappedValue: entitlementManager)
        self._purchaseManager = StateObject(wrappedValue: purchaseManager)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .dynamicTypeSize(.small...)
                .dynamicTypeSize(...DynamicTypeSize.large)
                .environmentObject(entitlementManager)
                .environmentObject(purchaseManager)
                .task {
                    await purchaseManager.updatePurchasedProducts()
                }
        }
    }
}

