//
//  GrammarView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/04/23.
//

import SwiftUI

struct GrammarView: View {
    @ObservedObject var vm = GrammarVM()
    
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
                                .opacity(vm.inputText.isEmpty ? 0.85 : 1)
                                .padding()
                            Spacer()
                        }
                        
                    }
                    .frame(minHeight: 200, maxHeight: reader.size.height - 200)
                    .padding()
                    
                }
                
                GrammarActionsView(vm: vm)
                
                if vm.loading {
                    CircularLoading()
                } else {

                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .padding()
                        
                        ZStack(alignment: .leading) {
                            
                            HStack {
                                VStack(alignment: .leading) {
                                        Text("\(vm.response?.choices[0].message.content ?? "")")
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
                }
                
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
