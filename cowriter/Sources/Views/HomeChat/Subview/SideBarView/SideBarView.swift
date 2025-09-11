//
//  SidebarView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 06/05/23.
//

import SwiftUI

struct SideBarView: View {
    @ObservedObject var vm: HomeVM
    var width: CGFloat
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            CustomRoundedRectangle(bottomRight: 12)
                .fill(.background)
                .edgesIgnoringSafeArea(.top)
            
            ListChat(vm: vm)
        }
        .transition(.move(edge: .leading))
        .frame(width: width)
        .offset(x: vm.showSideBar ? width / 2 : 0)
        .onChange(of: vm.currentChat, perform: { newValue in
            if vm.favoriteFilterIsOn {
                vm.favoriteFilterIsOn.toggle()
            }
        })
    }
}

struct SideBarView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarView(vm: HomeVM(), width: UIScreen.screenWidth - 100)
            .environmentObject(EntitlementManager())
    }
}
