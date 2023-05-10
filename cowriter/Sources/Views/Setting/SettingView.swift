//
//  SettingView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/05/23.
//

import SwiftUI

struct SettingView: View {
    @State private var isShowSheet: Bool = false
    @State private var selectedPlan: PlanEnum = PlanEnum.annual
    @State private var key: String = ""
    
    @EnvironmentObject private var entitlementManager: EntitlementManager
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    var body: some View {
        let isPro = entitlementManager.hasPro
        
        List {
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

                        if !isPro {
                            Divider()
                            Button {
                                isShowSheet.toggle()
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
                    .customFont()
                    .padding(.vertical, 5)
                    .foregroundColor(.darkGrayFont)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    isShowSheet.toggle()
                }
            }
            
            Section("Test", content: {
                TextField("Test", text: $key)
                Button("Submit") {
                    let yes = Keychain.saveApiKey(apiKey: key)
                    print(yes)
                }
            })
            
        }
        .navigationTitle("Setting")
        .sheet(isPresented: $isShowSheet) {
            
            if #available(iOS 16.0, *) {
                SubscriptionView(isShowSheet: $isShowSheet)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            } else {
                VStack {
                    CowriterLogo(isPro: true).padding(.top, 100).padding(.bottom, 75)
                    SubscriptionView(isShowSheet: $isShowSheet)
                }
            }
            
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
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
