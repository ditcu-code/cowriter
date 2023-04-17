//
//  ResultCard.swift
//  cowriter
//
//  Created by Aditya Cahyo on 17/04/23.
//

import SwiftUI

struct ResultCard: View {
    var prevPrompt: String
    var result: String
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 12) {
                Circle().fill(.gray).opacity(0.5).frame(width: 12)
                Text(prevPrompt)
                    .customFont(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }.padding(.horizontal, 5)
            Divider()
            Text(result)
                .customFont(24, .darkGrayFont)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .transition(.scale)
        }
        .padding(22)
        .background(RoundedRectangle(cornerRadius: 12).fill(.background).shadow(radius: 1))
        .padding(.horizontal)
    }
}

struct ResultCard_Previews: PreviewProvider {
    static var previews: some View {
        ResultCard(prevPrompt: "Hello", result: "hello")
    }
}
