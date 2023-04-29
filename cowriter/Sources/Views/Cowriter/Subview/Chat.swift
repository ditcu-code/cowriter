//
//  Chat.swift
//  cowriter
//
//  Created by Aditya Cahyo on 26/04/23.
//

import SwiftUI

struct Chat: View {
    @StateObject var vm: CowriterVM = CowriterVM()
    @Namespace private var bottomID
    @State private var isScrolled = false
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                ForEach(vm.currentChat?.resultsArray ?? []) { result in
                    let isLastResult = result.wrappedId == vm.currentChat?.resultsArray.last?.wrappedId
                    BubbleChat(prompt: result.wrappedPrompt)
                    BubbleChat(answer: isLastResult && vm.errorMessage.isEmpty ? vm.textToDisplay : result.wrappedAnswer)
                    if isLastResult {
                        Spacer().id(bottomID)
                    }
                }
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
            .onReceive(vm.$textToDisplay.throttle(for: 0.5, scheduler: DispatchQueue.main, latest: true)) { output in
                vm.textToDisplay = output
            }
        }
    }
}

struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        Chat(vm: CowriterVM())
    }
}

struct BubbleChat: View {
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
        .animation(.linear, value: answer)
        .padding(.horizontal)
    }
}
