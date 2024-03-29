//
//  ErrorMessageView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 30/04/23.
//

import SwiftUI

struct ErrorMessageView: View {
    var message: String?
    
    var body: some View {
        if let text = message {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                Text(text).font(.subheadline)
                Spacer()
            }
            .foregroundColor(.pink.opacity(0.75))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.pink.opacity(0.1))
            )
            .padding(.horizontal)
            .padding(.top, 10)
            .transition(.move(edge: .bottom))
        }
    }
}

struct ErrorMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorMessageView(message: "Error")
    }
}
