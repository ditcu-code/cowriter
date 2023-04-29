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
    var sideViewWidth: CGFloat = UIScreen.screenWidth - 100
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .font : UIFont(name: "Gill Sans", size: 18)!,
            .foregroundColor: UIColor.systemGray
        ]
    }
    
    var body: some View {
        let isActive = vm.oldChats.isEmpty
        NavigationView {
            ZStack {
                Color.gray.opacity(0.2).ignoresSafeArea()
                
                if !vm.errorMessage.isEmpty {
                    Text(vm.errorMessage).padding()
                }
                
                HStack {
                    if isShowing {
                        ZStack(alignment: .topLeading) {
                            Rectangle()
                                .fill(.white)
                                .cornerRadius(30, corners: [.bottomRight])
                                .edgesIgnoringSafeArea(.top)
                            
                            VStack {
                                List(vm.oldChats) { item in
                                    Text("hellossdadsdas")
                                }.listStyle(.plain)
                                Button("New Chat") {
                                    print("")
                                }
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
                        
                        Prompter(vm: vm)
                        
                        if isActive {
                            PromptHint(vm: vm)
                        }
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isShowing {
                            withAnimation(.interpolatingSpring(stiffness: 150, damping: 20)){
                                isShowing.toggle()
                            }
                        }
                    }
                    .frame(width: isShowing ? UIScreen.screenWidth : nil)
                    .offset(x: isShowing ? sideViewWidth / 2 : 0)
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(vm.currentChat?.wrappedTitle ?? "")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("setting")
                    } label: {
                        Label("Hello", systemImage: "gearshape")
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

struct CowriterView_Previews: PreviewProvider {
    static var previews: some View {
        CowriterView()
    }
}
