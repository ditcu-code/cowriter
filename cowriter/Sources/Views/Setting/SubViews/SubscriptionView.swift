//
//  SubscriptionView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 06/05/23.
//

import SwiftUI

struct SubscriptionView: View {
    var withLogo: Bool
    @Binding var isShowSheet: Bool
    @EnvironmentObject private var revenueCatService: RevenueCatService
    
    @State private var selectedPackage: PaywallPackage?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if withLogo {
                Spacer()
                HStack {
                    Spacer()
                    LogoView(isPro: true)
                    Spacer()
                }
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text("_upgrade_to_pro")
                    .bold()
                    .font(.title)
                    .padding(.top, 5)
                Text("_unlimited_anytime")
                    .font(.footnote)
                    .foregroundColor(.grayFont)
            }.padding()
            
            if revenueCatService.isLoading {
                HStack {
                    Spacer()
                    CircularLoading()
                    Spacer()
                }
            } else {
                ItemPlanView(selectedPackage: $selectedPackage)
            }
            
            VStack(spacing: 0) {
                Button {
                    if let pkg = selectedPackage {
                        revenueCatService.purchasePackage(pkg)
                        isShowSheet.toggle()
                    }
                } label: {
                    Spacer()
                    Text("_continue").bold()
                        .padding(.vertical, 5)
                    Spacer()
                }.buttonStyle(.borderedProminent).tint(.accentColor)
                
                Button {
                    revenueCatService.restorePurchases()
                    isShowSheet.toggle()
                } label: {
                    Text("_restore_purchase")
                        .font(.footnote)
                        .bold().padding(.vertical, 5)
                }
                .padding(.vertical, 10)
                .tint(.darkGrayFont)
                
                Text(.init("_subscription_auto_renewal"))
                    .font(.caption2)
                    .scaleEffect(0.9)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.defaultFont)
                
            }.padding()
        }
        .task {
            if revenueCatService.packages.isEmpty {
                revenueCatService.loadOfferings()
            }
        }
        .dynamicTypeSize(.medium)
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView(withLogo: true, isShowSheet: .constant(true))
            .environmentObject(RevenueCatService(entitlementManager: EntitlementManager()))
    }
}
