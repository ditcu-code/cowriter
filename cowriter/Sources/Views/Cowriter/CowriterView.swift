//
//  CowriterView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import SwiftUI

struct CowriterView: View {
    @ObservedObject var vm: CowriterVM = CowriterVM()
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    var body: some View {
        let isActive = vm.history.isEmpty
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
                                ForEach(vm.history, id: \.id) {item in
                                    let isLastItem = vm.history.last == item
                                    ResultCard(
                                        prevPrompt: item.prompt,
                                               result: isLastItem ? vm.text : item.result,
                                               isLoading: isLastItem && vm.isLoading
                                    )
                                    .id(item.id)
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
                .navigationTitle(vm.text.isEmpty ? "" : "Cowriter")
            }
            .onChange(of: vm.text, perform: { _ in
                withAnimation {
                    scrollProxy?.scrollTo(vm.history.last?.id, anchor: .bottom)
                }
            })
            .toolbar {
                Button {
                    print("")
                } label: {
                    Label("Hello", systemImage: "gearshape")
                }
            }
            .animation(.linear, value: isActive)
        }
        .onReceive(vm.$text.throttle(for: 0.1, scheduler: DispatchQueue.main, latest: true)) { output in
            withAnimation {
                vm.text = output
            }
        }
        .customFont()
    }
}

struct CowriterView_Previews: PreviewProvider {
    static var previews: some View {
        CowriterView()
    }
}
