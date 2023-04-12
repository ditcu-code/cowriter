//
//  SendButton.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import SwiftUI

struct SendButton: View {
    var body: some View {
        Button(action: {
            // button action here
        }, label: {
            Image(systemName: "paperplane.fill")
                .font(.footnote)
                .foregroundColor(.white)
                .padding(6)
                .background(.orange)
                .clipShape(Circle())
        })
    }
}

struct SendButton_Previews: PreviewProvider {
    static var previews: some View {
        SendButton()
    }
}
