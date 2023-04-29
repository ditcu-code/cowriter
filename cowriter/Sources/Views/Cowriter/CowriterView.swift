//
//  CowriterView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import SwiftUI

struct CowriterView: View {
    @ObservedObject var vm: CowriterVM = CowriterVM()
    @State private var scrollProxy: ScrollViewProxy?
    @State private var isShowing: Bool = false
    private var sideViewWidth: CGFloat = UIScreen.screenWidth - 100
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .font : UIFont(name: "Gill Sans", size: 18)!,
            .foregroundColor: UIColor.systemGray
        ]
    }
    
    private func closeSideBar() {
        withAnimation(.interpolatingSpring(stiffness: 150, damping: 20)){
            isShowing = false
        }
    }
    
    var body: some View {
        let isActive = vm.currentChat == nil
        NavigationView {
            ZStack {
                Color.gray.opacity(0.2).ignoresSafeArea()
                
                HStack {
                    if isShowing {
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
                                                closeSideBar()
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
                                    closeSideBar()
                                } label: {
                                    Spacer()
                                    Label("New chat", systemImage: "plus")
                                        .foregroundColor(.grayFont)
                                    Spacer()
                                }.buttonStyle(.bordered)
                                
                            }.padding()
                        }
                        .transition(.move(edge: .leading))
                        .frame(width: sideViewWidth)
                        .offset(x: isShowing ? sideViewWidth / 2 : 0)
                    }
                    VStack {
                        Spacer()
                        
                        if isActive {
                            CowriterLogo().padding(.top, 100)
                        } else {
                            Chat(vm: vm)
                        }
                        
                        if !vm.errorMessage.isEmpty {
                            Text(vm.errorMessage)
                                .foregroundColor(.pink.opacity(0.75))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.pink.opacity(0.1))
                                )
                                .transition(.move(edge: .bottom))
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
                            closeSideBar()
                        }
                    }
                    .frame(width: isShowing ? UIScreen.screenWidth : nil)
                    .offset(x: isShowing ? sideViewWidth / 2 : 0)
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(isShowing ? "" : vm.currentChat?.wrappedTitle ?? "")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("setting")
                    } label: {
                        Label("Hello", systemImage: "gearshape")
                    }.offset(x: isShowing ? sideViewWidth / 2 : 0)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    HamburgerToClose(isOpened: $isShowing)
                }
            }
            .animation(.linear, value: isActive)
        }.customFont()
    }
}

struct CowriterView_Previews: PreviewProvider {
    static var previews: some View {
        CowriterView()
    }
}
