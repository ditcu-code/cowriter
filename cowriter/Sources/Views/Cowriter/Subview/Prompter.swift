//
//  Prompter.swift
//  cowriter
//
//  Created by Aditya Cahyo on 15/04/23.
//

import SwiftUI

struct Prompter: View {
    @StateObject var vm: CowriterVM
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20.0)
                .fill(.background)
                .frame(height: 38)
            HStack {
                TextField("Tell cowriter to...", text: $vm.userMessage)
                    .font(.custom("Gill Sans", size: 17, relativeTo: .headline))
                    .padding(.horizontal)
                    .onSubmit {
                        vm.request()
                    }
                    .disabled(vm.isLoading)
                if vm.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                        .padding(.horizontal, 10)
                } else {
                    SendButton(vm: vm).padding(.horizontal, 5)
                }
            }.animation(.linear, value: vm.isLoading)
        }
        .padding(.horizontal)
        .padding(.top, 4)
        .padding(.bottom, 12)
    }
}