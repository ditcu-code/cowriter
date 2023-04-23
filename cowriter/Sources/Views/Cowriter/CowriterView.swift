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
                        ScrollViewReader { scrollView in
                            ScrollView {
                                ForEach(vm.oldChats, id: \.id) {chat in
                                    ResultCard(chat: chat, vm: vm).id(chat.id)
                                }
                                .onAppear {
                                    scrollProxy = scrollView
                                }
                            }
                        }

                    }
                    
                    Prompter(vm: vm)
                    
                    if isActive {
                        PromptHint(vm: vm)
                    }
                    
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(vm.textToDisplay.isEmpty ? "" : "Cowriter")
            }
            .onChange(of: vm.textToDisplay, perform: { _ in
                withAnimation {
                    scrollProxy?.scrollTo(vm.oldChats.last?.id, anchor: .bottom)
                }
            })
            .toolbar {
                Button {
                    print("setting")
                } label: {
                    Label("Hello", systemImage: "gearshape")
                }
            }
            .animation(.linear, value: isActive)
        }
        .onReceive(vm.$textToDisplay.throttle(for: 0.1, scheduler: DispatchQueue.main, latest: true)) { output in
//            withAnimation {
                vm.textToDisplay = output
//            }
        }
        .customFont()
    }
}

struct CowriterView_Previews: PreviewProvider {
    static var previews: some View {
        CowriterView()
    }
}
