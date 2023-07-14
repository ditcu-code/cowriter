//
//  Prompter.swift
//  cowriter
//
//  Created by Aditya Cahyo on 15/04/23.
//

import SwiftUI

struct Prompter: View {
    @StateObject var vm: HomeVM
    @FocusState var hasFocus: Bool

    var body: some View {
        HStack(alignment: .bottom) {
            ScrollView {
                TextEditor(text: $vm.userMessage)
                    .focused($hasFocus)
                    .padding(.horizontal, 12)
                    .font(Font.system(.body, design: .serif))
                    .frame(maxHeight: 200)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.background)
                            .frame(minHeight: 36)
                    )
                    .overlay {
                        if !hasFocus && vm.userMessage.isEmpty {
                            HStack {
                                Text("Tell Cowriter to...")
                                    .font(Font.system(.body, design: .serif))
                                    .padding(.horizontal, 16)
                                    .foregroundColor(.gray)
                                    .onTapGesture {
                                        hasFocus = true
                                    }
                                Spacer()
                            }
                        }
                    }
                    .onChange(of: vm.prompterHasFocus) {
                        hasFocus = $0
                    }
                    .onChange(of: hasFocus) {
                        vm.prompterHasFocus = $0
                    }
            }.fixedSize(horizontal: false, vertical: true)
            SendButton(loading: vm.isLoading) {
                if !vm.isLoading {
                    if vm.currentChat == nil {
                        vm.request(nil)
                    } else {
                        vm.request(vm.currentChat)
                    }
                }
            }
            .frame(height: 36)
            .padding(.leading, 5)
        }
        .animation(.linear, value: vm.isLoading)
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

struct PrompterView_Previews: PreviewProvider {
    static var previews: some View {
        Prompter(vm: HomeVM())
            .background(.gray)
    }
}
