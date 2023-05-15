//
//  AsisstView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 01/05/23.
//

import SwiftUI

struct AsisstView: View {
    @State private var text: String = ""
    @FocusState private var textEditor: Bool
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .leading) {
                
                if text.isEmpty {
                    VStack {
                        Text("Write something...")
                            .padding(.top, 10)
                            .padding(.leading, 6)
                            .opacity(0.6)
                            .padding()
                        Spacer()
                    }.onAppear{
                        textEditor = true
                    }
                }
                
                VStack {
                    TextEditor(text: $text)
                        .submitLabel(.done)
                        .onChange(of: text, perform: { newValue in
                            text = String(newValue.prefix(1000))
                        })
                        .opacity(text.isEmpty ? 0.85 : 1)
                        .padding()
                        .focused($textEditor)

//                    Text("\(text.count)/1000")
                    Spacer()
                }
                
            }
//            .frame(minHeight: 200, maxHeight: reader.size.height - 200)
            .padding()
        }
    }
}

struct AsisstView_Previews: PreviewProvider {
    static var previews: some View {
        AsisstView()
    }
}
