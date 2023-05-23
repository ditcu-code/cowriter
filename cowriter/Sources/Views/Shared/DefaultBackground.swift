//
//  DefaultBackground.swift
//  cowriter
//
//  Created by Aditya Cahyo on 18/05/23.
//

import SwiftUI

struct DefaultBackground: View {
    var body: some View {
        LinearGradient(
            colors: [.gray.opacity(0.15), .gray.opacity(0.25)],
            startPoint: .top,
            endPoint: .bottom
        ).ignoresSafeArea()
    }
}

struct DefaultBackground_Previews: PreviewProvider {
    static var previews: some View {
        DefaultBackground()
    }
}
