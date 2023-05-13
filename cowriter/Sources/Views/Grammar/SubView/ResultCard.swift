//
//  ResultCard.swift
//  cowriter
//
//  Created by Aditya Cahyo on 17/04/23.
//

import SwiftUI

struct ResultCard: View {
    var chat: Chat
    @StateObject var vm: CowriterVM
    
    @State private var selectedResultId: String = ""
    
    var body: some View {
        let isActiveChat = vm.currentChat == chat
        let isLoading = isActiveChat && vm.isLoading
        
        VStack(alignment: .leading, spacing: 20) {
            ForEach(chat.wrappedMessages) { result in
                let isLastResult = result == chat.wrappedMessages.last
                let isFirstResult = result == chat.wrappedMessages.first
//                let isSelectedAnswer = (selectedResultId == result.wrappedId.uuidString) ||
//                ((selectedResultId == "") && isLastResult)

                if isFirstResult {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(isLastResult && isLoading ? .orange : .gray)
                            .opacity(0.5)
                            .frame(width: 12)
                        Text(result.wrappedContent)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }.padding(.horizontal, 5)
                    Divider()
                } else {
                    ZStack {
                        Divider()
                        PromptTextView(prompt: result.wrappedContent, isLoading: isLastResult && isLoading)
                    }
                }

                AnswerTextView(
                    selectedResultId: $selectedResultId,
                    resultId: result.wrappedId.uuidString,
                    chat: chat,
                    answerStream: isActiveChat && isLastResult && vm.errorMessage.isEmpty ? vm.textToDisplay : result.wrappedContent,
                    vm: vm
                )
                
            }
        }
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background)
                .shadow(radius: 1)
        )
        .padding(.horizontal)
        .padding(.bottom, 5)
        .animation(.easeOut(duration: 0.2), value: selectedResultId)
        .onTapGesture {
            print(chat.wrappedMessages)
        }
    }
}

//struct ResultCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultCard(
//            chat: ChatModel(results: []),
//            isLastResult: true,
//            vm: CowriterVM()
//        )
//    }
//}

struct PromptTextView: View {
    var prompt: String
    var isLoading: Bool
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 9, height: 9)
                .foregroundColor(isLoading ? .orange : .gray)
                .opacity(0.5)
            Text(prompt)
                .lineLimit(2)
        }
        .padding(.vertical, 2)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.background)
                .shadow(radius: 1)
                .frame(minHeight: 23)
        )
        .frame(maxWidth: 200, alignment: .center)
    }
}

struct AnswerTextView: View {
    @Binding var selectedResultId: String
    var resultId: String
    var chat: Chat
    var answerStream: String
    @StateObject var vm: CowriterVM
    
    var body: some View {
        let isSelected = selectedResultId == resultId
        
        Group {
            Text(answerStream)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .transition(.scale)
                .onTapGesture {
                    if isSelected {
                        selectedResultId = ""
                    } else {
                        selectedResultId = resultId
                    }
                }
            if isSelected {
                HStack(spacing: 15) {
                    RefreshButton {
                        vm.userMessage = "Create another"
                        vm.request(chat)
                    }
//                    MagicButton(act: print("magicbutton"))
                }
            }
        }
        .animation(.easeOut, value: selectedResultId)
        .animation(.linear, value: answerStream)
    }
}
