//
//  EditorView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/07/23.
//

import SwiftUI

struct EditorView: View {
    @State var str: String = ""
    @FocusState var hasFocus: Bool

    var body: some View {
        VStack {
            TextEditor(text: $str)
                .padding()
                .focused($hasFocus)
                .font(Font.system(.body, design: .serif))
                .overlay {
                    if !hasFocus && str.isEmpty {
                        VStack {
                            HStack(alignment: .top) {
                                Text("Start writing...")
                                    .font(Font.system(.body, design: .serif))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 25)
                                    .foregroundColor(.gray)
                                    .onTapGesture {
                                        hasFocus = true
                                    }
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }

            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 0) {
                    ButtonEditor(icon: "pencil.line", text: "Continue") {
                        print("grammar")
                    }
                    ButtonEditor(icon: "star.bubble", text: "Ask AI") {
                        print("grammar")
                    }
                    ButtonEditor(icon: "text.badge.checkmark", text: "Grammar") {
                        print("grammar")
                    }
                    ButtonEditor(icon: "wand.and.stars", text: "Rephrase") {
                        print("ask ai")
                    }
                    TranslateButton {
                        print("ask ai")
                    }
                    ButtonEditor(icon: "music.mic", text: "Change\ntone") {
                        print("ask ai")
                    }
                    ButtonEditor(icon: "decrease.quotelevel", text: "Make\nshorter", rotateDegree: 90) {
                        print("ask ai")
                    }
                    ButtonEditor(icon: "increase.quotelevel", text: "Make\nlonger", rotateDegree: 90) {
                        print("ask ai")
                    }
                    ButtonEditor(icon: "text.quote", text: "Summarize") {
                        print("ask ai")
                    }

                }.padding(.horizontal)
            }
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView()
    }
}

struct ButtonEditor: View {
    let icon: String
    let text: String
    var rotateDegree: Double?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Circle()
                    .fill(Color.accentColor)
                    .overlay {
                        Image(systemName: icon)
                            .font(.headline)
                            .foregroundColor(.answerBubble)
                            .rotationEffect(Angle(degrees: rotateDegree ?? 0))
                    }.frame(width: 45).padding(.horizontal, 11)
                Text(text).font(.caption2)
            }
        }
    }
}

struct TranslateButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Circle()
                    .fill(Color.accentColor)
                    .overlay {
                        ZStack {
                            Image(systemName: "character.bubble")
                                .foregroundColor(.white)
                                .offset(x: -5, y: -5)
                                .scaleEffect(x: -1, y: 1)
                            Image(systemName: "character.bubble.fill.zh")
                                .foregroundColor(.white)
                                .offset(x: -5, y: 5)
                        }.scaleEffect(0.7)
                    }.frame(width: 45).padding(.horizontal, 11)
                Text("Translate").font(.caption2)
            }
        }
    }
}
