//
//  CowriterView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import SwiftUI

struct CowriterView: View {
    @ObservedObject var vm: CowriterVM = CowriterVM()
    @State private var isShowing: Bool = false
    private var sideBarWidth: CGFloat = UIScreen.screenWidth - 100
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .font : UIFont(name: "Gill Sans", size: 18)!,
            .foregroundColor: UIColor.systemGray
        ]
    }
    
    var body: some View {
        let isActive = vm.currentChat == nil
        NavigationView {
            ZStack {
                Color.gray.opacity(0.2).ignoresSafeArea()
                
                HStack {
                    if isShowing {
                        SideBarView(vm: vm, isShowing: $isShowing, width: sideBarWidth)
                    }
                    VStack {
                        Spacer()
                        
                        if isActive {
                            CowriterLogo().padding(.top, 100)
                        } else {
                            ChatView(vm: vm)
                        }
                        
                        if !vm.errorMessage.isEmpty {
                            ErrorMessageView(message: vm.errorMessage)
                        }
                        
                        Prompter(vm: vm, isActive: isActive)
                        
                        if isActive {
                            PromptHint(vm: vm)
                        }
                        
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isShowing {
                            closeSideBar($isShowing)
                        }
                    }
                    .frame(width: isShowing ? UIScreen.screenWidth : nil)
                    .offset(x: isShowing ? sideBarWidth / 2 : 0)
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(isShowing ? "" : vm.currentChat?.wrappedTitle ?? "")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingView()
                    } label: {
                        Label("Setting", systemImage: "gearshape")
                            .offset(x: isShowing ? sideBarWidth / 2 : 0)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    HamburgerToClose(isOpened: $isShowing)
                }
            }
            .animation(.linear, value: isActive)
        }.customFont()
    }
}

struct SideBarView: View {
    @StateObject var vm: CowriterVM
    @Binding var isShowing: Bool
    var width: CGFloat
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(.background)
                .cornerRadius(16, corners: [.bottomRight])
                .edgesIgnoringSafeArea(.top)
            
            VStack(alignment: .leading) {
                Text("Chats")
                List(vm.allChats) { item in
                    let isActiveChat = vm.currentChat == item
                    HStack {
                        Text(item.wrappedTitle)
                            .lineLimit(1)
                            .foregroundColor(.grayFont)
                            .onTapGesture {
                                vm.currentChat = item
                                closeSideBar($isShowing)
                            }
                        if isActiveChat {
                            Spacer()
                            Circle()
                                .frame(width: 9, height: 9)
                                .foregroundColor(.orange)
                        }
                    }
                }.listStyle(.plain)
                
                Button {
                    vm.currentChat = nil
                    closeSideBar($isShowing)
                } label: {
                    Spacer()
                    Label("New chat", systemImage: "plus")
                        .foregroundColor(.grayFont)
                    Spacer()
                }.buttonStyle(.bordered)
                
            }.padding()
        }
        .transition(.move(edge: .leading))
        .frame(width: width)
        .offset(x: isShowing ? width / 2 : 0)
    }
}

fileprivate func closeSideBar(_ isShowing: Binding<Bool>) {
    withAnimation(.interpolatingSpring(stiffness: 150, damping: 20)){
        isShowing.wrappedValue = false
    }
}

struct CowriterView_Previews: PreviewProvider {
    static var previews: some View {
        CowriterView()
    }
}
