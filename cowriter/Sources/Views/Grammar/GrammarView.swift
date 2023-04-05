//
//  GrammarView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/04/23.
//

import SwiftUI

struct GrammarView: View {
    @State var words: String = ""
    
    var body: some View {
        GeometryReader { reader in
            ScrollView {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .padding(.horizontal)
                    
                    ZStack(alignment: .leading) {
                        
                        if words.isEmpty {
                            VStack {
                                Text("Write something...")
                                    .padding(.top, 10)
                                    .padding(.leading, 6)
                                    .opacity(0.6)
                                    .padding()
                                Spacer()
                            }
                        }
                        
                        VStack {
                            TextEditor(text: $words)
                                .opacity(words.isEmpty ? 0.85 : 1)
                                .padding()
//                            Text("\(reader.size.height) \(reader.size.width)")

                            Spacer()
                        }
                        

                        
                    }
                    .frame(minHeight: 200, maxHeight: reader.size.height - 200)
                    .padding()
                    
                }
                
                GrammarActionsView()
                
            }
        }
        .background(Color.gray.opacity(0.1))
        
    }
}

struct GrammarView_Previews: PreviewProvider {
    static var previews: some View {
        GrammarView()
    }
}


