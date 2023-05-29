//
//  cowriterView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm: HomeVM = HomeVM()
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    private let sideBarWidth: CGFloat = UIScreen.screenWidth - 100
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.systemGray
        ]
    }
    
    var body: some View {
        let isActive = vm.currentChat == nil
        
        NavigationView {
            ZStack {
                DefaultBackground()
                
                HStack {
                    if vm.showSideBar {
                        SideBarView(vm: vm, width: sideBarWidth)
                    }
                    
                    VStack {
                        Spacer()
                        
                        if isActive {
                            GreetingView(parentVm: vm)
                        } else {
                            ChatView(vm: vm)
                        }
                        
                        if !vm.errorMessage.isEmpty {
                            ErrorMessageView(message: vm.errorMessage)
                        }
                        Spacer()
                        
                        Prompter(vm: vm)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        vm.closeSideBar()
                        vm.removePrompterFocus()
                    }
                    .onChange(of: isActive, perform: { newValue in
                        if newValue {
                            vm.removePrompterFocus()
                        }
                    })
                    .frame(width: vm.showSideBar ? UIScreen.screenWidth : nil)
                    .offset(x: vm.showSideBar ? sideBarWidth / 2 : 0)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(vm.showSideBar ? "" : vm.currentChat?.wrappedTitle ?? "")
            .toolbar {
                HomeToolbar(vm: vm, width: sideBarWidth)
            }
            .task(priority: .background) {
                await vm.getAssets()
                await vm.updateUsage()
            }
            .animation(.linear, value: isActive)
        }
        .sheet(isPresented: $vm.showSubscriptionSheet) {
            SubscriptionView(withLogo: true, isShowSheet: $vm.showSubscriptionSheet)
        }
    }
}

struct CowriterView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(PurchaseManager(entitlementManager: EntitlementManager()))
    }
}
