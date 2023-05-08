//
//  CowriterView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import SwiftUI

struct CowriterView: View {
    @ObservedObject var vm: CowriterVM = CowriterVM()
    private var sideBarWidth: CGFloat = UIScreen.screenWidth - 100
    @FocusState var isFocusOnPrompt: Bool
    
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
                HStack {
                    if vm.showSideBar {
                        SideBarView(vm: vm, width: sideBarWidth)
                    }
                    VStack {
                        Spacer()
                        
                        if isActive {
                            GreetingView().padding(.horizontal)
                            //                            CowriterLogo().padding(.top, 100)
                        } else {
                            ChatView(vm: vm)
                        }
                        
                        if !vm.errorMessage.isEmpty {
                            ErrorMessageView(message: vm.errorMessage)
                        }
                        Spacer()
                        
                        Prompter(vm: vm, isActive: isActive, isFocused: _isFocusOnPrompt)
                        
                        //                        if isActive {
                        //                            PromptHint(vm: vm)
                        //                        }
                        
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if vm.showSideBar {
                            vm.closeSideBar()
                        }
                        if isFocusOnPrompt {
                            isFocusOnPrompt = false
                        }
                    }
                    .onChange(of: isActive, perform: { newValue in
                        if isFocusOnPrompt {
                            isFocusOnPrompt = false
                        }
                    })
                    .frame(width: vm.showSideBar ? UIScreen.screenWidth : nil)
                    .offset(x: vm.showSideBar ? sideBarWidth / 2 : 0)
                }
                
            }
            .background(.linearGradient(
                colors: [.gray.opacity(0.15), .gray.opacity(0.25)],
                startPoint: .top,
                endPoint: .bottom
            ))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(vm.showSideBar ? "" : vm.currentChat?.wrappedTitle ?? "")
            .toolbar {
                CowriterToolbarView(vm: vm, width: sideBarWidth)
            }
            .animation(.linear, value: isActive)
        }
    }
}

struct CowriterView_Previews: PreviewProvider {
    static var previews: some View {
        CowriterView()
    }
}
