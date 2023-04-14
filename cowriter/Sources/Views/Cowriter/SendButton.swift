//
//  SendButton.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import SwiftUI

struct SendButton: View {
    @StateObject var vm: CowriterVM

    var body: some View {
        Button(action: {
            
        }, label: {
            Image(systemName: "paperplane.fill")
                .font(.footnote)
                .foregroundColor(.white)
                .padding(6)
                .background(.orange)
                .clipShape(Circle())
        })
        .disabled(vm.loading)
    }
}