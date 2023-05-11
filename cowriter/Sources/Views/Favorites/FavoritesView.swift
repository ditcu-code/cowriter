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
            LinearGradient(
                colors: [.gray.opacity(0.15), .gray.opacity(0.25)],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            VStack {
                if let list = vm.allFavorites {
                    //                let filteredList = list.filter { $0.isFavorite }
                    
                    if list.isEmpty {
                        HStack {
                            Spacer()
                            Text("Looks like you haven't favorited any messages")
                                .multilineTextAlignment(.center)
                                .font(.subheadline)
                                .foregroundColor(.defaultFont)
                                .padding(.vertical, 100)
                                .frame(maxWidth: 200)
                            Spacer()
                        }
                    }
                    
                    ScrollView {
                        ForEach(list) { result in
                            let isLastResult = result.wrappedId == list.last?.wrappedId
                            let isPrompt = result.isPrompt
                            
                            if isPrompt {
                                BubblePromptView(result: result, prompt: result.wrappedMessage)
                            } else {
                                BubbleAnswerView(
                                    result: result,
                                    answer: result.wrappedMessage
                                )
                            }
                            
                            if isLastResult {
                                Spacer()
                            }
                        }.animation(.linear, value: list.count)
                    }
                }
            }
        }.navigationBarTitle("Favorites")
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(vm: FavoritesVM())
    }
}
