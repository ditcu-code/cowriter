//
//  CowriterView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import SwiftUI

struct CowriterView: View {
    @ObservedObject var vm: CowriterVM = CowriterVM()
    @State private var scrollProxy: ScrollViewProxy?
    
    var body: some View {
        let isActive = vm.oldChats.isEmpty
        NavigationView {
            ZStack {
                Color.gray.opacity(0.2).ignoresSafeArea()
                
                if !vm.errorMessage.isEmpty {
                    Text(vm.errorMessage).padding()
                }
                
                VStack {
                    if isActive {
                        CowriterLogo().padding(.top, 100)
                    } else {
                        Chat(vm: vm)
                    }
                    
                    Prompter(vm: vm)
                    
                    if isActive {
                        PromptHint(vm: vm)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(vm.oldChats.isEmpty ? "" : vm.currentChat!.wrappedTitle)
            }
            .toolbar {
                Button {
                    print("setting")
                } label: {
                    Label("Hello", systemImage: "gearshape")
                }
            }
            .animation(.linear, value: isActive)
        }.customFont()
    }
}

struct CowriterView_Previews: PreviewProvider {
    static var previews: some View {
        CowriterView()
    }
}
