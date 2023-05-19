//
//  swiftChatApp.swift
//  swiftChat
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
                .dynamicTypeSize(.small...)
                .dynamicTypeSize(...DynamicTypeSize.large)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(entitlementManager)
                .environmentObject(purchaseManager)
                .task {
                    await purchaseManager.updatePurchasedProducts()
                }
        }
    }
}

