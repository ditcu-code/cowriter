//
//  CowriterLogo.swift
//  cowriter
//
//  Created by Aditya Cahyo on 15/04/23.
//

import SwiftUI

struct CowriterLogo: View {
    var body: some View {
        HStack(spacing: -5) {
            Text("cowriter").font(.custom("Gill Sans", size: 48))
            Text(".")
                .font(.custom("Gill Sans", size: 48))
                .foregroundColor(.orange)
        }
    }
}

struct CowriterLogo_Previews: PreviewProvider {
    static var previews: some View {
        CowriterLogo()
    }
}
