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
    @State private var isScrolled = false
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                ForEach(vm.currentChat?.resultsArray ?? []) { result in
                    let isLastResult = result.wrappedId == vm.currentChat?.resultsArray.last?.wrappedId
                    
                    BubbleChatView(prompt: result.wrappedPrompt)
                        .transition(.move(edge: .bottom))
                    BubbleChatView(answer:
                                (isLastResult && vm.errorMessage.isEmpty && vm.isLoading) ?
                               vm.textToDisplay : result.wrappedAnswer
                    ).transition(.move(edge: .leading))
                    
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
            .onReceive(vm.$textToDisplay.throttle(for: 0.5, scheduler: DispatchQueue.main, latest: true)) { output in
                vm.textToDisplay = output
            }
        }
    }
}

struct BubbleChatView: View {
    var prompt: String?
    var answer: String?
    
    var body: some View {
        let isUser = answer == nil && prompt != nil
        
        HStack {
            if isUser {
                Spacer(minLength: 50)
            }
            Text((isUser ? prompt : answer) ?? "")
                .textSelection(.enabled)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(
                    Rectangle()
                        .fill(isUser ? .orange.opacity(0.9) : .gray.opacity(0.15))
                        .cornerRadius(12, corners: [.bottomLeft, .bottomRight, isUser ? .topLeft : .topRight])
                        .cornerRadius(3, corners: [isUser ? .topRight : .topLeft])
                )
                .customFont(18, isUser ? .white : .darkGrayFont)
            if !isUser {
                Spacer(minLength: 50)
            }
        }
        .padding(.horizontal)
        .animation(.linear, value: answer)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(vm: CowriterVM())
    }
}
