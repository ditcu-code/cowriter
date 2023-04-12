//
//  GrammarView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/04/23.
//

import SwiftUI

struct GrammarView: View {
    @ObservedObject var vm = GrammarVM()
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
//                    ThreeDots(loading: $vm.loading)
                } else {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .padding()
                        
                        ZStack(alignment: .leading) {
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(Utils.removeNewlineAtBeginning(!isRephrase ? vm.responseCompletion?.choices[0].text ?? "" : vm.responseChat?.choices[0].message.content ?? ""))")
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

struct ThreeDots: View {
    @State var loading = false
    
    var body: some View {
        HStack(spacing: 20) {
            Circle()
                .fill(Color.orange)
                .frame(width: 10, height: 10)
                .scaleEffect(loading ? 1.5 : 0.5)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: loading)
            Circle()
                .fill(Color.orange)
                .frame(width: 10, height: 10)
                .scaleEffect(loading ? 1.5 : 0.5)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(0.2), value: loading)
            Circle()
                .fill(Color.orange)
                .frame(width: 10, height: 10)
                .scaleEffect(loading ? 1.5 : 0.5)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(0.4), value: loading)
        }
        .onAppear() {
            self.loading = true
        }
    }
}

struct ThreeDots_Previews: PreviewProvider {
    static var previews: some View {
        ThreeDots()
    }
}
