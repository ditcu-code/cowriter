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
    @StateObject var vm = SettingVM()
    
    @EnvironmentObject private var entitlementManager: EntitlementManager
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    var body: some View {
        List {
            ProfileView(vm: vm)
            
            subscriptionSection
            
            Section {
                appearanceSetting
                
                Button {
                    purchaseManager.restorePurchases()
                } label: {
                    LabelSetting(icon: "arrow.2.squarepath", color: .defaultFont, label: "Restore Purchase")
                }
                
                Button {
                    vm.showSupportSheet = true
                } label: {
                    LabelSetting(icon: "questionmark.bubble", color: .grayFont, label: "Support")
                }
                
            }
            
            Section {
                ForEach(MarkdownEnum.allCases, id: \.rawValue) { markdown in
                    MarkdownView(type: markdown)
                }
            }
            
        }
        .navigationTitle("Setting")
        .sheet(isPresented: $vm.showSubscriptionSheet) {
            
            if #available(iOS 16.0, *) {
                SubscriptionView(isShowSheet: $vm.showSubscriptionSheet)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            } else {
                VStack {
                    LogoView(isPro: true)
                        .padding(.top, 100)
                        .padding(.bottom, 75)
                    SubscriptionView(isShowSheet: $vm.showSubscriptionSheet)
                }
            }
            
        }
        
        .sheet(isPresented: $vm.showSupportSheet) {
            NavigationView {
                VStack {
                    TextField("Subject", text: $vm.subject)
                    Divider()
                    TextField("Email", text: $vm.email)
                        .textContentType(.emailAddress)
                    Divider()
                    ZStack {
                        TextEditor(text: $vm.content)
                            .foregroundColor(Color.gray)
                    }
                }
                .navigationTitle("Support")
                .navigationBarTitleDisplayMode(.inline)
                .padding()
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Send") {
                            Task {
                                await vm.sendSupportMessage()
                                vm.showSupportSheet = false
                            }
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Back") {
                            vm.showSupportSheet = false
                        }
                    }
                }
            }
        }
    }
    
    private var appearanceSetting: some View {
        Menu {
            Picker(selection: appData.$preferredColorScheme) {
                ForEach(AppearanceMode.allCases, id: \.self) { item in
                    Label(item.rawValue.capitalized, systemImage: item.icon)
                        .font(.callout).tag(item)
                }
            } label: {}
        } label: {
            HStack {
                LabelSetting(
                    icon: appData.preferredColorScheme.icon,
                    color: .init(white: 0.2),
                    label: "Appearance"
                )
                Spacer()
                HStack {
                    Text(appData.preferredColorScheme.rawValue.capitalized)
                        .font(.subheadline).foregroundColor(.darkGrayFont)
                    Image(systemName: "chevron.up.chevron.down")
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
                            LogoView(isPro: true)
                        } else {
                            Text("Free Plan").bold().tracking(0.5)
                        }
                        Text("\(isPro ? "Unlimited" : "Limited") chats")
                            .font(.footnote)
                            .foregroundColor(.defaultFont)
                        
                        if !isPro {
                            Divider()
                            Button {
                                vm.showSubscriptionSheet.toggle()
                            } label: {
                                Text("Upgrade to Pro")
                                    .bold()
                                    .font(.subheadline)
                                    .foregroundColor(.accentColor)
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
                    isPro ? nil : vm.showSubscriptionSheet.toggle()
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
