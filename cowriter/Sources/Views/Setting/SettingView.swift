//
//  SettingView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/05/23.
//

import Combine
import SwiftUI

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
                    LabelSetting(icon: "arrow.2.squarepath", color: .defaultFont, label: "restore_purchase")
                }
                
                Button {
                    vm.showSupportSheet = true
                } label: {
                    LabelSetting(icon: "questionmark.bubble", color: .grayFont, label: "support")
                }
            }
            
            Section {
                ForEach(MarkdownEnum.allCases, id: \.rawValue) { markdown in
                    LegalView(type: markdown)
                }
            }
        }
        .navigationTitle("setting")
        .sheet(isPresented: $vm.showSubscriptionSheet) {
            SubscriptionView(withLogo: true, isShowSheet: $vm.showSubscriptionSheet)
        }
        
        .sheet(isPresented: $vm.showSupportSheet) {
            NavigationView {
                VStack {
                    TextField("title", text: $vm.subject)
                    Divider()
                    TextField("email", text: $vm.email)
                        .textContentType(.emailAddress)
                    Divider()
                    ZStack {
                        TextEditor(text: $vm.content)
                            .foregroundColor(Color.gray)
                    }
                }
                .navigationTitle("support")
                .navigationBarTitleDisplayMode(.inline)
                .padding()
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("send") {
                            Task {
                                await vm.sendSupportMessage()
                                vm.showSupportSheet = false
                            }
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("title") {
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
                    Label(NSLocalizedString(item.rawValue, comment: ""), systemImage: item.icon)
                        .font(.callout).tag(item)
                }
            } label: {}
        } label: {
            HStack {
                LabelSetting(
                    icon: appData.preferredColorScheme.icon,
                    color: .init(white: 0.2),
                    label: "appearance")
                Spacer()
                HStack {
                    Text(NSLocalizedString(
                        appData.preferredColorScheme.rawValue, comment: "")
                    )
                    .font(.subheadline).foregroundColor(.darkGrayFont)
                    Image(systemName: "chevron.up.chevron.down")
                }
            }
        }
    }
    
    private var subscriptionSection: some View {
        let isPro = entitlementManager.hasPro
        
        return (
            Section("subscription") {
                HStack {
                    isPro ? Spacer() : nil
                    VStack(alignment: isPro ? .center : .leading) {
                        if isPro {
                            LogoView(isPro: true)
                        } else {
                            Text("free_plan").bold().tracking(0.5)
                        }
                        Text(isPro ? "limited_chats" : "unlimited_chats")
                            .font(.footnote)
                            .foregroundColor(.defaultFont)
                        
                        if !isPro {
                            Divider()
                            Button {
                                vm.showSubscriptionSheet.toggle()
                            } label: {
                                Text("upgrade_to_pro")
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
