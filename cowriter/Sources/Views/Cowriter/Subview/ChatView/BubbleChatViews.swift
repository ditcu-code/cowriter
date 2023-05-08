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
                .padding(.horizontal)
                .padding(.vertical, 12)
                .font(Font.system(.body, design: .serif))
                .foregroundColor(.white)
                .background(
                    shape.fill(LinearGradient(
                            gradient: Gradient(colors: [.black.opacity(0.8), .black.opacity(0.7)]),
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
        .padding(.trailing)
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
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(
                    shape.fill(Color.answerBubble)
                )
                .font(Font.system(.body, design: .serif))
                .foregroundColor(.darkGrayFont)
                .contentShape(.contextMenuPreview, shape)
                .contextMenu {
                    ChatContextMenu()
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
        }
    }
}

struct ChatContextMenu: View {
    var body: some View {
        Group {
            Button {
                // Add this item to a list of favorites.
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }
            Button {
                // Open Maps and center it on this item.
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            Divider()
            Button {
                // Open Maps and center it on this item.
            } label: {
                Label("Regenerate", systemImage: "arrow.clockwise")
            }
        }
    }
}
