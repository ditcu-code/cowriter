//
//  Chat.swift
//  cowriter
//
//  Created by Aditya Cahyo on 26/04/23.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var vm: HomeVM
    @Namespace private var bottomID
    @State private var isScrolled: Bool = false
    
    var body: some View {
        ScrollViewReader { scrollView in
            
            if let list = vm.currentChat?.wrappedMessages {
                let filteredList = list.filter { $0.isFavorite }
                let activeList = vm.favoriteFilterIsOn ? filteredList : list
                
                if activeList.isEmpty {
                    HStack {
                        Spacer()
                        Text("No favorites in this chat")
                            .foregroundColor(.defaultFont)
                            .padding(.vertical, 100)
                        Spacer()
                    }
                }
                
                ScrollView {
                    ForEach(activeList) { message in
                        let isLastMessage = message.wrappedId == list.last?.wrappedId
                        let isPrompt = message.wrappedRole == ChatRoleEnum.user.rawValue
                        
                        if isPrompt {
                            BubblePromptView(message: message, prompt: message.wrappedContent)
                        } else {
                            BubbleAnswerView(
                                message: message,
                                answer: (isLastMessage && vm.errorMessage == nil && vm.isLoading) ?
                                vm.textToDisplay : message.wrappedContent
                            )
                        }
                        
                        if isLastMessage {
                            Spacer().id(bottomID)
                        }
                    }.animation(.linear, value: activeList.count)
                }
                .gesture(DragGesture().onChanged{ value in
                    isScrolled = true
                })
                .onChange(of: vm.isLoading, perform: { newValue in
                    if isScrolled == true {
                        isScrolled = !newValue
                    }
                })
                .onReceive(vm.$textToDisplay.throttle(for: 0.25, scheduler: DispatchQueue.main, latest: true)) { output in
                    vm.textToDisplay = output
                    if !isScrolled {
                        withAnimation {
                            scrollView.scrollTo(bottomID, anchor: .bottom)
                        }
                    }
                }
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(vm: HomeVM())
    }
}
