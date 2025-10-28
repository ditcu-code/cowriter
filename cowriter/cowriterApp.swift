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
    @StateObject private var revenueCatService: RevenueCatService
    
    init() {
        let entitlementManager = EntitlementManager()
        let rc = RevenueCatService(entitlementManager: entitlementManager)
        self._entitlementManager = StateObject(wrappedValue: entitlementManager)
        self._revenueCatService = StateObject(wrappedValue: rc)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .dynamicTypeSize(.small...)
                .dynamicTypeSize(...DynamicTypeSize.large)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(entitlementManager)
                .environmentObject(revenueCatService)
                .task {
                    revenueCatService.configureIfPossible()
                    revenueCatService.refreshCustomerInfo()
                }
        }
    }
}
