//
//  SidebarView.swift
//  swiftChat
//
//  Created by Aditya Cahyo on 06/05/23.
//

import SwiftUI

struct SideBarView: View {
    @ObservedObject var vm: HomeVM
    var width: CGFloat
    
    @State private var showSubscriptionSheet: Bool = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            CustomRoundedRectangle(bottomRight: 12)
                .fill(.background)
                .edgesIgnoringSafeArea(.top)
            
            ListChat(vm: vm, showSubscriptionSheet: $showSubscriptionSheet)
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

fileprivate struct ListChat: View {
    @ObservedObject var vm: HomeVM
    @EnvironmentObject private var entitlementManager: EntitlementManager
    
    @State private var editMode: EditMode = .inactive
    @State private var isEditing: Bool = false
    @Binding var showSubscriptionSheet: Bool
    
    var body: some View {
        let hasReachedLimit = vm.allChats.count >= 3
        let isPro = entitlementManager.hasPro
        
        VStack(alignment: .leading) {
            if !vm.allChats.isEmpty {
                HStack {
                    Text("Chats").bold()
                    Spacer()
                    Button("Edit") {
                        isEditing.toggle()
                    }
                }
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
                }.onDelete(perform: editMode == .active ? vm.removeChat : nil)
            }
            .listStyle(.plain)
            .id(editMode.isEditing.description)
            .environment(\.editMode, $editMode)
            .onChange(of: isEditing, perform: { isEditing in
                editMode = isEditing ? .active : .inactive
            })
            
            Spacer()
            NewChatButton {
                if hasReachedLimit && !isPro {
                    showSubscriptionSheet.toggle()
                } else {
                    vm.currentChat = nil
                    vm.closeSideBar()
                    vm.errorMessage = ""
                    vm.favoriteFilterIsOn = false
                }
            }
        }.padding()
    }
}

fileprivate struct EmptyChatView: View {
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

fileprivate struct NewChatButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action){
            Spacer()
            Label("New chat", systemImage: "plus").font(.headline)
            Spacer()
        }.buttonStyle(.bordered)
    }
}

struct SideBarView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarView(vm: HomeVM(), width: UIScreen.screenWidth - 100)
            .environmentObject(EntitlementManager())
    }
}
