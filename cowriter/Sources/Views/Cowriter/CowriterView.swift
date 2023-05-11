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
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.systemGray
        ]
    }
    
    var body: some View {
        let isActive = vm.currentChat == nil
        
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [.gray.opacity(0.15), .gray.opacity(0.25)],
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()
                
                HStack {
                    if vm.showSideBar {
                        SideBarView(vm: vm, width: sideBarWidth)
                    }
                    
                    VStack {
                        Spacer()
                        
                        if isActive {
                            GreetingView()
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
