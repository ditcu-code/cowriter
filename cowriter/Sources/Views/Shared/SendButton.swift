//
//  SendButton.swift
//  cowriter
//
//  Created by Aditya Cahyo on 11/07/23.
//

import SwiftUI

struct SendButton: View {
    let loading: Bool
    let action: () -> Void

    var body: some View {
        Button(action:
            action,
            label: {
                Circle()
                    .overlay {
                        if loading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.75)
                                .padding(.horizontal, 10)
                        } else {
                            Image(systemName: "paperplane.fill")
                                .font(.footnote)
                                .foregroundColor(.white)
                        }
                    }.frame(width: 36)
            })
    }
}

struct SendButton_Previews: PreviewProvider {
    static var previews: some View {
        SendButton(loading: true) {
            print("clicked")
        }
    }
}
