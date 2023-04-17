//
//  CowriterView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import SwiftUI

struct CowriterView: View {
    @ObservedObject var vm: CowriterVM = CowriterVM()
    @State var textToDisplay = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.2).ignoresSafeArea()
                
                VStack {
                    
                    if textToDisplay.isEmpty {
                        CowriterLogo()
                    } else {
                        ScrollView {
                            Spacer()
                            ResultCard(prevPrompt: vm.text, result: textToDisplay)
                        }
                    }
                    
                    Prompter(vm: vm)
                    
                    if textToDisplay.isEmpty {
                        PromptHint(vm: vm)
                    }
                    
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(textToDisplay.isEmpty ? "" : "Cowriter")
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
                self.textToDisplay = output
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
