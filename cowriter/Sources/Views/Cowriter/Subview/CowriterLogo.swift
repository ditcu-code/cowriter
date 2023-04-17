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
            Text("cowriter").customFont(48, .grayFont)
            Text(".").customFont(48, .orange)
        }
    }
}

struct CowriterLogo_Previews: PreviewProvider {
    static var previews: some View {
        CowriterLogo()
    }
}
