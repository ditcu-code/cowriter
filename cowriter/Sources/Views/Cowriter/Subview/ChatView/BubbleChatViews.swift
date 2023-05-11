//
//  BubbleChatViews.swift
//  cowriter
//
//  Created by Aditya Cahyo on 08/05/23.
//

import SwiftUI

struct BubblePromptView: View {
    @StateObject var result: ResultType
    var prompt: String
    private let shape = CustomRoundedRectangle(
        topLeft: 12, topRight: 3, bottomLeft: 12, bottomRight: 12
    )
    
    var body: some View {
        HStack {
            Spacer(minLength: 50)
            Text(prompt)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .font(Font.system(.body, design: .serif))
                .foregroundColor(.white)
                .background(
                    shape.fill(LinearGradient(
                        gradient: Gradient(colors: [
                            Color.init(red: 0.3, green: 0.5, blue: 0.7),
                            Color.init(red: 0.1, green: 0.3, blue: 0.5)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                )
                .overlay(
                    BubbleFavoriteFlag(isFavorite: result.isFavorite, isPrompt: result.isPrompt)
                )
                .contentShape(.contextMenuPreview, shape)
                .clipShape(shape)
                .contextMenu {
                    BubbleContextMenu(result: result)
                }
        }
        .padding(.horizontal)
        .animation(.linear, value: prompt)
        .transition(.upAndLeft)
    }
}

struct BubbleAnswerView: View {
    @StateObject var result: ResultType
    var answer: String
    private let shape = CustomRoundedRectangle(
        topLeft: 3, topRight: 12, bottomLeft: 12, bottomRight: 12
    )
    
    var body: some View {
        HStack {
            Text(answer)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .frame(minWidth: 70)
                .background(
                    shape.fill(Color.answerBubble)
                )
                .overlay(
                    answer.isEmpty ? ThreeDotsLoading().scaleEffect(0.5) : nil
                )
                .overlay(
                    BubbleFavoriteFlag(isFavorite: result.isFavorite, isPrompt: result.isPrompt)
                )
                .font(Font.system(.body, design: .serif))
                .foregroundColor(.darkGrayFont)
                .contentShape(.contextMenuPreview, shape)
                .clipShape(shape)
                .contextMenu {
                    BubbleContextMenu(result: result)
                }
            Spacer(minLength: 50)
        }
        .badge(10)
        .padding(.horizontal)
        .padding(.trailing)
        .animation(.linear, value: answer)
        .transition(.move(edge: .leading))
    }
}

struct BubbleContextMenu: View {
    @StateObject var result: ResultType
    
    var body: some View {
        Group {
            Button {
                UIPasteboard.general.setValue(result.message ?? "", forPasteboardType: "public.plain-text")
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }
            Button {
                result.isFavorite.toggle()
            } label: {
                Label(
                    result.isFavorite ? "Unfavorite" : "Favorite",
                    systemImage: result.isFavorite ? "star.slash.fill" : "star"
                )
            }
            if !result.isPrompt {
                Divider()
                Button {
                    
                } label: {
                    Label("Regenerate", systemImage: "arrow.clockwise")
                }
            }
        }
    }
}

struct BubbleFavoriteFlag: View {
    var isFavorite: Bool = false
    var isPrompt: Bool
    
    var body: some View {
        VStack {
            HStack {
                if !isPrompt {
                    Spacer()
                }
                Triangle()
                    .fill(isFavorite ? (isPrompt ? .white : .blue) : .clear)
                    .opacity(0.75)
                    .frame(width: 23, height: 23)
                    .rotationEffect(.degrees(isPrompt ? -90 : .zero))
                if isPrompt {
                    Spacer()
                }
            }
            Spacer()
        }
    }
}

//struct BubbleChatViews_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            BubblePromptView(result: ResultType(), prompt: "Hello")
//            BubbleAnswerView(result: ResultType(), answer: "")
//            Spacer()
//        }.background(.gray)
//    }
//}
