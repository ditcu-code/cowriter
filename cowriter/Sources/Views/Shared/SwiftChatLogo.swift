//
//  SwiftChatLogo.swift
//  swiftChat
//
//  Created by Aditya Cahyo on 15/04/23.
//

import SwiftUI

struct SwiftChatLogo: View {
    var isPro: Bool = false
    
    var body: some View {
        HStack(spacing: isPro ? 0 : -5) {
            Text("SwiftChat").gillFont(48, .grayFont)
            Text(isPro ? "pro" : ".").gillFont(48, .blue)
        }
    }
}

struct CowriterLogo_Previews: PreviewProvider {
    static var previews: some View {
        SwiftChatLogo(isPro: true)
    }
}
