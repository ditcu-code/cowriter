//
//  SettingView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/05/23.
//

import SwiftUI
import Combine

struct SettingView: View {
    @ObservedObject var appData = AppData()
    @State private var showSubscriptionSheet: Bool = false
    
    @EnvironmentObject private var entitlementManager: EntitlementManager
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    private let mode = ["light", "dark", "system"]
    
    var body: some View {
        List {
            ProfileView()
            
            subscriptionSection
            
            Section("Preference") {
                Picker(selection: appData.$preferredColorScheme) {
                    ForEach(AppearanceMode.allCases, id: \.self) { item in
                        Label(item.rawValue.capitalized, systemImage: item.icon)
                            .labelStyle(.iconOnly)
                            .tag(item)
                    }
                } label: {
                    Text("Theme")
                }
            }
            
        }
        .navigationTitle("Setting")
        .sheet(isPresented: $showSubscriptionSheet) {
            
            if #available(iOS 16.0, *) {
                SubscriptionView(isShowSheet: $showSubscriptionSheet)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            } else {
                VStack {
                    CowriterLogo(isPro: true).padding(.top, 100).padding(.bottom, 75)
                    SubscriptionView(isShowSheet: $showSubscriptionSheet)
                }
            }
            
        }
    }
    
    private var subscriptionSection: some View {
        let isPro = entitlementManager.hasPro
        
        return (
            Section("Subscription") {
                HStack {
                    isPro ? Spacer() : nil
                    VStack(alignment: isPro ? .center : .leading) {
                        if isPro {
                            CowriterLogo(isPro: true)
                        } else {
                            Text("Free Plan").bold().tracking(0.5)
                        }
                        Text("\(isPro ? "Unlimited" : "Limited") chats")
                            .font(.footnote)
                            .foregroundColor(.defaultFont)
                        
                        if !isPro && !purchaseManager.products.isEmpty {
                            Divider()
                            Button {
                                showSubscriptionSheet.toggle()
                            } label: {
                                Text("Upgrade to Pro")
                                    .bold()
                                    .font(.footnote)
                                    .foregroundColor(.blue)
                                    .padding(.top, 5)
                            }
                        }
                    }
                    .animation(.linear, value: isPro)
                    .padding(.vertical, 5)
                    .foregroundColor(.darkGrayFont)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    isPro ? nil : showSubscriptionSheet.toggle()
                }
            })
    }
    
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(appData: AppData())
            .environmentObject({ () -> PurchaseManager in
                let envObj = PurchaseManager(entitlementManager: EntitlementManager())
                return envObj
            }())
            .environmentObject({ () -> EntitlementManager in
                let envObj = EntitlementManager()
                return envObj
            }())
    }
}
