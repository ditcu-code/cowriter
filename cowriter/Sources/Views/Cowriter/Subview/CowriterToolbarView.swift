//
//  CowriterToolbarView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 08/05/23.
//

import SwiftUI

struct CowriterToolbarView: ToolbarContent {
    @StateObject var vm: CowriterVM
    var width: CGFloat
    
    @State private var toolbarShow: Bool = false
    
    var body: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingView()
                } label: {
                    if toolbarShow {
                        Label("Setting", systemImage: "gearshape")
                            .offset(x: vm.showSideBar ? width / 2 : 0)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
                .animation(
                    .interpolatingSpring(stiffness: 30, damping: 15),
                    value: toolbarShow
                )
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                ZStack {
                    if toolbarShow {
                        HamburgerToClose(isOpened: $vm.showSideBar)
                            .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                }
                .animation(
                    .interpolatingSpring(stiffness: 30, damping: 15),
                    value: toolbarShow
                )
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        toolbarShow.toggle()
                    }
                }
            }
        }
    }
}
