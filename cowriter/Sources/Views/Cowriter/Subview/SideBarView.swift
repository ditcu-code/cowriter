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
                                vm.closeSideBar()
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
                    vm.closeSideBar()
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
        .offset(x: vm.showSideBar ? width / 2 : 0)
    }
}

struct SideBarView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarView(vm: CowriterVM(), width: UIScreen.screenWidth - 100)
    }
}
