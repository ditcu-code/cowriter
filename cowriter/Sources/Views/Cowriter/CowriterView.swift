//
//  CowriterView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import SwiftUI

struct CowriterView: View {
    @ObservedObject var vm: CowriterVM = CowriterVM()

    var body: some View {
        let isActive = vm.history.isEmpty
        NavigationView {
            ZStack {
                Color.gray.opacity(0.2).ignoresSafeArea()
                
                VStack {
                    if isActive {
                        CowriterLogo().padding(.top, 100)
                    } else {
                        ScrollView {
                            Spacer()
                            ForEach(vm.history) {item in
                                let isLastItem = vm.history.last == item 
                                ResultCard(prevPrompt: item.prompt, result: isLastItem ? vm.text : item.result, isLoading: isLastItem && vm.isLoading)
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
            .toolbar {
                Button {
                    print("")
                } label: {
                    Label("Hello", systemImage: "gearshape")
                }
            }
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
