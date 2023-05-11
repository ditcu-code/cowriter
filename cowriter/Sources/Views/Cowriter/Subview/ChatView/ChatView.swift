//
//  Chat.swift
//  cowriter
//
//  Created by Aditya Cahyo on 26/04/23.
//

import SwiftUI

struct ChatView: View {
    @StateObject var vm: CowriterVM
    @Namespace private var bottomID
    @State private var isScrolled: Bool = false
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                ForEach(vm.currentChat?.resultsArray ?? []) { result in
                    let isLastResult = result.wrappedId == vm.currentChat?.resultsArray.last?.wrappedId
                    let isPrompt = result.isPrompt
                    
                    if isPrompt {
                        BubblePromptView(prompt: isPrompt ? result.wrappedMessage : "")
                    } else {
                        BubbleAnswerView(
                            answer: (isLastResult && vm.errorMessage.isEmpty && vm.isLoading) ?
                            vm.textToDisplay : result.wrappedMessage
                        )
                    }
                    
                    if isLastResult {
                        Spacer().id(bottomID)
                    }
                }.animation(.linear, value: vm.currentChat?.resultsArray.count)
            }
            
            .gesture(DragGesture().onChanged{ value in
                isScrolled = true
            })
            .onChange(of: vm.textToDisplay) { newValue in
                if !isScrolled {
                    withAnimation {
                        scrollView.scrollTo(bottomID)
                    }
                }
            }
            .onChange(of: vm.isLoading, perform: { newValue in
                if isScrolled == true {
                    isScrolled = !newValue
                }
            })
            .onReceive(vm.$textToDisplay.throttle(for: 0.2, scheduler: DispatchQueue.main, latest: true)) { output in
                vm.textToDisplay = output
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(vm: CowriterVM())
    }
}
