//
//  Prompter.swift
//  cowriter
//
//  Created by Aditya Cahyo on 15/04/23.
//

import SwiftUI
import iTextField

struct Prompter: View {
    @StateObject var vm: CowriterVM
    
    var body: some View {
        HStack {
            iTextField(
                "Tell Swift to...",
                text: $vm.userMessage,
                isEditing: $vm.isFocusOnPrompter
            )
            .onReturn {
                if !vm.isLoading {
                    if vm.currentChat == nil {
                        vm.request(nil)
                    } else {
                        vm.request(vm.currentChat)
                    }
                }
                vm.isFocusOnPrompter = true
            }
            .fontFromUIFont(UIFont(
                descriptor: UIFont.systemFont(ofSize: 15).fontDescriptor.withDesign(.serif)!,
                size: 15
            ))
            .foregroundColor(.darkGrayFont)
            .padding(.horizontal)
            if vm.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .padding(.horizontal, 10)
            }
        }
        .animation(.linear, value: vm.isLoading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background)
                .frame(height: 38)
        )
        .padding()
    }
}

struct PrompterView_Previews: PreviewProvider {
    static var previews: some View {
        Prompter(vm: CowriterVM())
    }
}
