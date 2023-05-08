//
//  SidebarView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 06/05/23.
//

import SwiftUI

struct SideBarView: View {
    @StateObject var vm: CowriterVM
    var width: CGFloat
    
    var body: some View {
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
                        vm.currentChat = nil
                        vm.closeSideBar()
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
