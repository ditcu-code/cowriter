//
//  GrammarView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/04/23.
//

import SwiftUI

struct GrammarView: View {
    @ObservedObject var vm: GrammarVM = GrammarVM()
    @State var isRephrase: Bool = false
    
    var body: some View {
        GeometryReader { reader in
            ScrollView {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .padding()
                    
                    ZStack(alignment: .leading) {
                        
                        if vm.inputText.isEmpty {
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
                            TextEditor(text: $vm.inputText)
                                .submitLabel(.done)
                                .onChange(of: vm.inputText, perform: { newValue in
                                    vm.inputText = String(newValue.prefix(1000))
                                })
                                .opacity(vm.inputText.isEmpty ? 0.85 : 1)
                                .padding()
                            Text(vm.textLang)
                            Text("\(vm.inputText.count)/1000")
                            Spacer()
                        }
                        
                    }
                    .frame(minHeight: 200, maxHeight: reader.size.height - 200)
                    .padding()
                    
                }
                
                GrammarActionsView(vm: vm, isRephrase: $isRephrase)
                
                if vm.loading {
                    ThreeDotsLoading()
                } else {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .padding()
                        
                        ZStack(alignment: .leading) {
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    let text = !isRephrase ? vm.responseCompletion?.choices[0].text ?? "" : vm.responseChat?.choices[0].message.content ?? ""
                                    Text("\(text.removeNewlineAtBeginning())")
                                        .padding(.top, 10)
                                        .padding(.leading, 6)
                                        .padding()
                                    Spacer()
                                }
                                Spacer()
                            }
                            
                            
                        }
                        .frame(minHeight: 0, maxHeight: reader.size.height - 200)
                        .padding()
                        
                    }.animation(.default, value: vm.loading)
                    
                    Button(action: {
                        // button action here
                    }, label: {
                        ZStack {
                            Image(systemName: "character.bubble.hi")
                                .offset(x: -5, y: 5)
                            Image(systemName: "character.bubble.fill")
                                .offset(x: -5, y: -5)
                                .scaleEffect(x: -1, y: 1)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                    })
                    
                }
                
            }
        }
        .background(Color.gray.opacity(0.1))
        
    }
}

//struct GrammarView_Previews: PreviewProvider {
//    static var previews: some View {
//        GrammarView()
//    }
//}

