//
//  CowriterLogo.swift
//  cowriter
//
//  Created by Aditya Cahyo on 15/04/23.
//

import SwiftUI

struct CowriterLogo: View {
    var isPro: Bool = false
    
    var body: some View {
        HStack(spacing: isPro ? 0 : -5) {
            Text("SwiftChat").customFont(48, .grayFont)
            Text(isPro ? "pro" : ".").customFont(48, .blue)
        }
    }
}

struct CowriterLogo_Previews: PreviewProvider {
    static var previews: some View {
        CowriterLogo(isPro: true)
    }
}
