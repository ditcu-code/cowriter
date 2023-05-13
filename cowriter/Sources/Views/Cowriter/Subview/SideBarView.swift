//
//  SidebarView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 06/05/23.
//

import SwiftUI

struct SideBarView: View {
    @ObservedObject var vm: CowriterVM
    @State private var showSubscriptionSheet: Bool = false
    @EnvironmentObject private var entitlementManager: EntitlementManager
    var width: CGFloat
    
    var body: some View {
        let hasReachedLimit = vm.allChats.count >= 1
        let isPro = entitlementManager.hasPro
        
        ZStack(alignment: .topLeading) {
            CustomRoundedRectangle(bottomRight: 12)
                .fill(.background)
                .edgesIgnoringSafeArea(.top)
            
            VStack(alignment: .leading) {
                if !vm.allChats.isEmpty {
                    Text("Chats").bold()
                } else {
                    EmptyChatView()
                }
                List {
                    ForEach(vm.allChats, id: \.self) { item in
                        let isActiveChat = vm.currentChat == item
                        HStack {
                            Text(item.wrappedTitle)
                                .lineLimit(1)
                                .foregroundColor(.grayFont)
                                .font(Font.system(.body, design: .serif))
                            Spacer()
                            if isActiveChat {
                                Circle()
                                    .frame(width: 9, height: 9)
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            vm.currentChat = item
                            vm.closeSideBar()
                        }
                    }.onDelete(perform: vm.removeChat)
                }.listStyle(.plain)
                
                
                Spacer()
                Button {
                    if hasReachedLimit && !isPro {
                        showSubscriptionSheet.toggle()
                    } else {
                        vm.currentChat = nil
                        vm.closeSideBar()
                        vm.errorMessage = ""
                        vm.favoriteFilterIsOn = false
                    }
                } label: {
                    Spacer()
                    Label("New chat", systemImage: "plus").font(.headline)
                    Spacer()
                }.buttonStyle(.bordered)
                
            }.padding()
        }
        .transition(.move(edge: .leading))
        .frame(width: width)
        .offset(x: vm.showSideBar ? width / 2 : 0)
        .onChange(of: vm.currentChat, perform: { newValue in
            if vm.favoriteFilterIsOn {
                vm.favoriteFilterIsOn.toggle()
            }
        })
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
