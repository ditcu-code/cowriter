//
//  swiftChatToolbarView.swift
//  swiftChat
//
//  Created by Aditya Cahyo on 08/05/23.
//

import SwiftUI

struct HomeToolbar: ToolbarContent {
    @ObservedObject var vm: HomeVM
    var width: CGFloat
    
    var body: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                ZStack {
                    if vm.showToolbar {
                        Hamburger(vm: vm)
                            .transition(
                                .move(edge: .leading)
                                .combined(with: .opacity)
                            )
                    }
                }
                .animation(
                    .interpolatingSpring(stiffness: 30, damping: 15),
                    value: vm.showToolbar
                )
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        vm.showToolbar = true
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if vm.currentChat != nil {
                    Button {
                        vm.favoriteFilterIsOn.toggle()
                    } label: {
                        Label("Favorites", systemImage: vm.favoriteFilterIsOn ? "star.bubble.fill" : "star.bubble")
                            .labelStyle(.iconOnly)
                            .offset(x: vm.showSideBar ? width / 2 : 0)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                    }.animation(
                        .interpolatingSpring(stiffness: 30, damping: 15),
                        value: vm.showToolbar
                    )
                } else {
                    ToolbarTrailing(
                        vm: vm,
                        width: width,
                        destinationView: FavoritesView(),
                        labelView: Label("Favorites", systemImage: "star")
                    )
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                ToolbarTrailing(
                    vm: vm,
                    width: width,
                    destinationView: SettingView(),
                    labelView: Label("Setting", systemImage: "gearshape")
                )
            }
        }
    }
}

fileprivate struct ToolbarTrailing<T: View, U: View>: View {
    @StateObject var vm: HomeVM
    var width: CGFloat
    let destinationView: T
    let labelView: U
    
    var body: some View {
        NavigationLink {
            destinationView
        } label: {
            if vm.showToolbar {
                labelView
                    .labelStyle(.iconOnly)
                    .offset(x: vm.showSideBar ? width / 2 : 0)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(
            .interpolatingSpring(stiffness: 30, damping: 15),
            value: vm.showToolbar
        )
    }
}
