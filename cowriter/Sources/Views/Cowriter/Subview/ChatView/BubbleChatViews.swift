//
//  BubbleChatViews.swift
//  cowriter
//
//  Created by Aditya Cahyo on 08/05/23.
//

import SwiftUI

struct BubblePromptView: View {
    var prompt: String
    var shape = CustomRoundedRectangle(topLeft: 12, topRight: 3, bottomLeft: 12, bottomRight: 12)
    
    var body: some View {
        HStack {
            Spacer(minLength: 50)
            Text(prompt)
                .textSelection(.enabled)
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
                .contentShape(.contextMenuPreview, shape)
                .contextMenu {
                    ChatContextMenu()
                }
        }
        .padding(.horizontal)
        .transition(.move(edge: .bottom))
    }
}

struct BubbleAnswerView: View {
    var answer: String
    var shape = CustomRoundedRectangle(topLeft: 3, topRight: 12, bottomLeft: 12, bottomRight: 12)
    
    var body: some View {
        
        HStack {
            Text(answer)
                .textSelection(.enabled)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    shape.fill(Color.answerBubble)
                )
                .font(Font.system(.body, design: .serif))
                .foregroundColor(.darkGrayFont)
                .contentShape(.contextMenuPreview, shape)
                .contextMenu {
                    ChatContextMenu(answer: answer)
                }
            Spacer(minLength: 50)
        }
        .padding(.horizontal)
        .padding(.trailing)
        .animation(.linear, value: answer)
        .transition(.move(edge: .leading))
    }
}

struct BubbleChatViews_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BubblePromptView(prompt: "Hello")
            BubbleAnswerView(answer: "Hello")
            Spacer()
        }.background(.gray)
    }
}

struct ChatContextMenu: View {
    var answer: String?
    
    var body: some View {
        Group {
            Button {
                
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }
            Button {
                
            } label: {
                Label("Favorite", systemImage: "star")
            }
            if answer != nil {
                Divider()
                Button {
                    
                } label: {
                    Label("Regenerate", systemImage: "arrow.clockwise")
                }
            }
        }
    }
}
