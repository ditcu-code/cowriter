//
//  ResultCard.swift
//  cowriter
//
//  Created by Aditya Cahyo on 17/04/23.
//

import SwiftUI

struct ResultCard: View {
    var chat: ChatType
    //    var chat: ChatModel
    //    var results: [ResultType]
    var isLastChat: Bool
    @StateObject var vm: CowriterVM
    
    @State var selectedResultId: String = ""
    
    var body: some View {
        let isLoading = isLastChat && vm.isLoading
        
        VStack(alignment: .leading, spacing: 20) {
            ForEach(chat.resultsArray) { result in
                
                let isLastResult = result == chat.resultsArray.last
                let isFirstResult = result == chat.resultsArray.first
                let isSelectedAnswer = (selectedResultId == result.wrappedId.uuidString) ||
                ((selectedResultId == "") && isLastResult)

                if isFirstResult {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(isLastResult && isLoading ? .orange : .gray)
                            .opacity(0.5)
                            .frame(width: 12)
                        Text(result.wrappedPrompt)
                            .customFont(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }.padding(.horizontal, 5)
                    Divider()
                } else {
                    ZStack {
                        Divider()
                        PromptText(prompt: result.wrappedPrompt, isLoading: isLastResult && isLoading)
                    }
                }

                AnswerText(
                    selectedResultId: $selectedResultId,
                    resultId: result.wrappedId.uuidString,
                    chatId: chat.wrappedId.uuidString,
                    answerStream: isLastChat && isLastResult ? vm.textToDisplay : result.wrappedAnswer,
                    vm: vm
                )
                .customFont(
                    isSelectedAnswer ? 22 : 18,
                    isSelectedAnswer ? .darkGrayFont : .defaultFont
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

struct PromptText: View {
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
                .customFont(14, .defaultFont)
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

struct AnswerText: View {
    @Binding var selectedResultId: String
    var resultId: String
    var chatId: String
    var answerStream: String
    @StateObject var vm: CowriterVM
    
    var body: some View {
        Group {
            Text(answerStream)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .transition(.scale)
                .onTapGesture {
                    if selectedResultId == resultId {
                        selectedResultId = ""
                    } else {
                        selectedResultId = resultId
                    }
                }
            if resultId == selectedResultId {
                HStack(spacing: 15) {
                    RefreshButton {
                        vm.userMessage = "Create another"
                        print("chatId", chatId)
                        vm.request(UUID(uuidString: chatId))
                    }
//                    MagicButton(act: print("magicbutton"))
                }
            }
        }
        .animation(.easeOut, value: selectedResultId)
        .animation(.linear(duration: 1), value: answerStream)
    }
}
