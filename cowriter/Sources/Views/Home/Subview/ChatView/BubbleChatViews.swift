//
//  BubbleChatViews.swift
//  cowriter
//
//  Created by Aditya Cahyo on 08/05/23.
//

import SwiftUI

struct BubblePromptView: View {
    @ObservedObject var message: Message
    var prompt: String
    
    private let shape = CustomRoundedRectangle(
        topLeft: 12, topRight: 3, bottomLeft: 12, bottomRight: 12
    )
    
    var body: some View {
        HStack {
            Spacer(minLength: 50)
            Text(.init(prompt))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .font(Font.system(.body, design: .serif))
                .foregroundColor(.white)
                .background(
                    shape.fill(LinearGradient(
                        gradient: Gradient(colors: [
                            Color.init(red: 0.25, green: 0.25, blue: 0.25),
                            Color.init(red: 0.4, green: 0.4, blue: 0.4)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                )
                .overlay(
                    BubbleFavoriteFlag(isFavorite: message.isFavorite, isPrompt: message.wrappedRole == ChatRoleEnum.user.rawValue)
                )
                .contentShape(.contextMenuPreview, shape)
                .clipShape(shape)
                .contextMenu {
                    BubbleContextMenu(message: message)
                }
        }
        .padding(.horizontal)
        .animation(.linear, value: prompt)
        .transition(.upAndLeft)
    }
}

struct BubbleAnswerView: View {
    @StateObject var message: Message
    var answer: String
    
    private let shape = CustomRoundedRectangle(
        topLeft: 3, topRight: 12, bottomLeft: 12, bottomRight: 12
    )
    
    var body: some View {
        HStack {
            Text(.init(answer))
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
                    BubbleFavoriteFlag(isFavorite: message.isFavorite, isPrompt: message.wrappedRole == ChatRoleEnum.user.rawValue)
                )
                .font(Font.system(.body, design: .serif))
                .foregroundColor(.darkGrayFont)
                .contentShape(.contextMenuPreview, shape)
                .clipShape(shape)
                .contextMenu {
                    BubbleContextMenu(message: message)
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

fileprivate struct BubbleContextMenu: View {
    @StateObject var message: Message
    
    var body: some View {
        Group {
            Button {
                UIPasteboard.general.setValue(message.content ?? "", forPasteboardType: "public.plain-text")
            } label: {
                Label("copy", systemImage: "doc.on.doc")
            }
            Button {
                message.isFavorite.toggle()
            } label: {
                Label(
                    message.isFavorite ? "unfavorite" : "favorite",
                    systemImage: message.isFavorite ? "star.slash.fill" : "star"
                )
            }
            
//            if message.wrappedRole != ChatRoleEnum.user.rawValue {
//                Divider()
//                Button {
//
//                } label: {
//                    Label("Regenerate", systemImage: "arrow.clockwise")
//                }
//            }
        }
    }
}

fileprivate struct BubbleFavoriteFlag: View {
    var isFavorite: Bool = false
    var isPrompt: Bool
    
    var body: some View {
        VStack {
            HStack {
                if !isPrompt {
                    Spacer()
                }
                Triangle()
                    .fill(isFavorite ? (isPrompt ? .white : .accentColor) : .clear)
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

struct BubbleChatViews_Previews: PreviewProvider {
    static var previews: some View {
        let moc = PersistenceController.shared.container.viewContext
        let message = Message(context: moc)
        
        VStack {
            BubblePromptView(message: message, prompt: "How are you")
            BubbleAnswerView(message: message, answer: "I am fine")
            Spacer()
        }
        .onAppear{
            message.content = "Hello"
        }
        .background(.gray)
    }
}
