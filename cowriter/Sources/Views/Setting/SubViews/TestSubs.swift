//
//  TestSubs.swift
//  cowriter
//
//  Created by Aditya Cahyo on 09/05/23.
//

import SwiftUI

struct TestSubs: View {
    @StateObject private var purchaseManager = PurchaseManager()
    
    var body: some View {
        TestStoreKit()
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

