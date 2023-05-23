//
//  LogoView.swift
//  swiftChat
//
//  Created by Aditya Cahyo on 15/04/23.
//

import SwiftUI

struct LogoView: View {
    var isPro: Bool = false
    
    var body: some View {
        HStack(spacing: isPro ? 0 : -5) {
            Text("Cowriter")
            Text(isPro ? "Pro" : ".").bold()
        }.font(Font.system(.title, design: .serif))
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView(isPro: true)
    }
}
