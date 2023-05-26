//
//  SubscriptionView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 06/05/23.
//

import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @Binding var isShowSheet: Bool
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    @State private var selectedProduct: Product?
    
    private let disclaimerText = "Your annual or monthly subscription will automatically renew until you choose to cancel it. Cancel any time in the App Store; your subscription will then cease at the end of the current term. By subscribingg, you agree to our [Terms And Conditions](https://bit.ly/cowriter-termsconditions), [Privacy Policy](https://bit.ly/cowriter-privacypolicy)"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Upgrade to Pro")
                    .bold()
                    .font(.title)
                    .padding(.top, 5)
                Text("Unlimited chats. Anytime")
                    .font(.footnote)
                    .foregroundColor(.grayFont)
            }.padding()
            
            if purchaseManager.isLoading {
                HStack {
                    Spacer()
                    CircularLoading()
                    Spacer()
                }
            } else {
                ItemPlanView(selectedProduct: $selectedProduct)
            }
            
            VStack(spacing: 0) {
                
                Button {
                    if let product = selectedProduct {
                        purchaseManager.purchaseProduct(product)
                        isShowSheet.toggle()
                    }
                } label: {
                    Spacer()
                    Text("Continue").bold()
                        .padding(.vertical, 5)
                    Spacer()
                }.buttonStyle(.borderedProminent).tint(.accentColor)
                
                Button {
                    purchaseManager.restorePurchases()
                    isShowSheet.toggle()
                } label: {
                    Text("Restore purchase")
                        .font(.footnote)
                        .bold().padding(.vertical, 5)
                }
                .padding(.vertical, 10)
                .tint(.darkGrayFont)
                
                Text(.init(disclaimerText))
                    .font(.caption2)
                    .scaleEffect(0.9)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.defaultFont)
                
            }.padding()
            
            Spacer()
        }
        .task {
            if purchaseManager.products.isEmpty {
                purchaseManager.loadProducts()
            }
        }
        .dynamicTypeSize(.medium)
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView(isShowSheet: .constant(true))
            .environmentObject(PurchaseManager.init(entitlementManager: EntitlementManager()))
    }
}
