//
//  SidebarView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 06/05/23.
//

import SwiftUI

struct SideBarView: View {
    @StateObject var vm: CowriterVM
    @State private var showSubscriptionSheet: Bool = false
    @EnvironmentObject private var entitlementManager: EntitlementManager
    var width: CGFloat
    
    var body: some View {
        let hasReachedLimit = vm.allChats.count >= 3
        let isPro = entitlementManager.hasPro
        
        ZStack(alignment: .topLeading) {
            CustomRoundedRectangle(bottomRight: 12)
                .fill(.background)
                .edgesIgnoringSafeArea(.top)
            
            VStack(alignment: .leading) {
                if !vm.allChats.isEmpty {
                    Text("Chats")
                } else {
                    EmptyChatView()
                }
                List(vm.allChats) { item in
                    let isActiveChat = vm.currentChat == item
                    HStack {
                        Text(item.wrappedTitle)
                            .lineLimit(1)
                            .foregroundColor(.grayFont)
                            .onTapGesture {
                                vm.currentChat = item
                                vm.closeSideBar()
                            }
                        if isActiveChat {
                            Spacer()
                            Circle()
                                .frame(width: 9, height: 9)
                                .foregroundColor(.blue)
                        }
                    }
                }.listStyle(.plain)
                
                
                if vm.currentChat != nil || vm.allChats.isEmpty {
                    Button {
                        if hasReachedLimit && !isPro {
                            showSubscriptionSheet.toggle()
                        } else {
                            vm.currentChat = nil
                            vm.closeSideBar()
                            vm.errorMessage = ""
                        }
                    } label: {
                        Spacer()
                        Label("New chat", systemImage: "plus")
                        Spacer()
                    }.buttonStyle(.bordered)
                }
                
            }.padding()
        }
        .customFont()
        .transition(.move(edge: .leading))
        .frame(width: width)
        .offset(x: vm.showSideBar ? width / 2 : 0)
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
}

struct SideBarView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarView(vm: CowriterVM(), width: UIScreen.screenWidth - 100)
    }
}

struct EmptyChatView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Image(systemName: "tray")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75)
                Text("No Chats Yet!").font(.headline)
                Spacer()
            }.foregroundColor(.gray.opacity(0.7))
            Spacer()
        }
    }
}
