//
//  ActionPrompt.swift
//  cowriter
//
//  Created by Aditya Cahyo on 17/04/23.
//

import SwiftUI

struct RefreshButton: View {
    var act: Void
    var body: some View {
        Button(action: {
            act
        }, label: {
            Image(systemName: "arrow.clockwise")
                .font(.callout)
                .padding(8)
                .padding(.bottom, 3)
                .padding(.leading, 1)
                .background(.background)
                .clipShape(Circle())
                .shadow(radius: 1)
        }).customFont()
    }
}

struct RefreshButton_Previews: PreviewProvider {
    static var previews: some View {
        RefreshButton(act: print(""))
    }
}
