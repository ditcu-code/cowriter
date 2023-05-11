//
//  MagicButton.swift
//  cowriter
//
//  Created by Aditya Cahyo on 17/04/23.
//

import SwiftUI

struct MagicButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "wand.and.stars")
                .font(.callout)
                .padding(8)
                .padding(.bottom, 2)
                .padding(.leading, 1)
                .background(.background)
                .clipShape(Circle())
                .shadow(radius: 1)
        }
    }
}

struct MagicButton_Previews: PreviewProvider {
    static var previews: some View {
        MagicButton {
            print("any magic button")
        }
    }
}
