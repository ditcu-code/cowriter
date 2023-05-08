//
//  Prompter.swift
//  cowriter
//
//  Created by Aditya Cahyo on 15/04/23.
//

import SwiftUI

struct Prompter: View {
    @StateObject var vm: CowriterVM
    var isActive: Bool
    @FocusState var isFocused: Bool
    
    var body: some View {
        HStack {
            TextField("Tell cowriter to...", text: $vm.userMessage)
                .customFont(17)
                .focused($isFocused)
                .padding(.horizontal)
                .onSubmit {
                    if !vm.isLoading {
                        if isActive {
                            vm.request(nil)
                        } else {
                            vm.request(vm.currentChat)
                        }
                    }
                }
                .disabled(vm.isLoading)
                .onChange(of: vm.userMessage) { newValue in
                    isFocused = true
                }
            if vm.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                    .padding(.horizontal, 10)
            }
        }
        .animation(.linear, value: vm.isLoading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background)
                .frame(height: 38)
        )
        .padding(.horizontal)
        .padding(.top, 4)
        .padding(.bottom, 8)
    }
}

struct PrompterView_Previews: PreviewProvider {
    static var previews: some View {
        Prompter(vm: CowriterVM(), isActive: true)
    }
}
