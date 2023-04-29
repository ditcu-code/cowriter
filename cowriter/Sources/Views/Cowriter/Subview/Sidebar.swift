//
//  Sidebar.swift
//  cowriter
//
//  Created by Aditya Cahyo on 29/04/23.
//

import SwiftUI

struct Sidebar: View {
    @Binding var isSidebarVisible: Bool

    var body: some View {
        if isSidebarVisible {
            Text("Sidebar visible")
                .bold()
                .font(.largeTitle)
                .background(.purple)
        }
    }
}
//
//struct Sidebar_Previews: PreviewProvider {
//    static var previews: some View {
//        Sidebar()
//    }
//}
