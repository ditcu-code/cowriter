//
//  HistoryView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var vm: FavoritesVM = FavoritesVM()
    
    var body: some View {
        ZStack {
            DefaultBackground()
            
            VStack {
                if let list = vm.allFavorites {
                    
                    if list.isEmpty {
                        HStack {
                            Spacer()
                            Text("no_favorites_messages")
                                .multilineTextAlignment(.center)
                                .font(.subheadline)
                                .foregroundColor(.defaultFont)
                                .padding(.vertical, 100)
                                .frame(maxWidth: 200)
                            Spacer()
                        }
                    }
                    
                    ScrollView {
                        ForEach(list) { message in
                            let isLastMessage = message.wrappedId == list.last?.wrappedId
                            let isPrompt = message.wrappedRole == ChatRoleEnum.user.rawValue
                            
                            if isPrompt {
                                BubblePromptView(message: message, prompt: message.wrappedContent)
                            } else {
                                BubbleAnswerView(
                                    message: message,
                                    answer: message.wrappedContent
                                )
                            }
                            
                            if isLastMessage {
                                Spacer()
                            }
                        }.animation(.linear, value: list.count)
                    }
                }
            }
        }.navigationBarTitle("favorites")
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(vm: FavoritesVM())
    }
}
