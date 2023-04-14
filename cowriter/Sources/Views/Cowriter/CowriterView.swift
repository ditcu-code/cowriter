//
//  CowriterView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import SwiftUI

struct CowriterView: View {
    @State var text: String = ""
    @ObservedObject var vm: CowriterVM = CowriterVM()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.2).ignoresSafeArea()
                VStack(spacing: 16) {
                    HStack(spacing: -5) {
                        Text("cowriter").font(.custom("Gill Sans", size: 48))
                        Text(".")
                            .font(.custom("Gill Sans", size: 48))
                            .foregroundColor(.orange)
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 20.0)
                            .fill(.background)
                            .frame(height: 38)
                        HStack {
                            TextField("Tell cowriter to...", text: $text)
                                .font(.custom("Gill Sans", size: 17, relativeTo: .headline))
                                .padding(.horizontal)
                                .onSubmit {
                                    print(text)
                                    vm.loading = true
                                    print(vm.loading)
                                }
                                .disabled(vm.loading)
                            
                            if vm.loading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                                    .padding(.horizontal, 10)
                            } else {
                                SendButton(vm: vm).padding(.horizontal, 5)
                            }
                        }.animation(.linear, value: vm.loading)
                    }.padding()
                }.navigationBarTitleDisplayMode(.inline)
            }
            .toolbar {
                Button {
                    print("")
                } label: {
                    Label("Hello", systemImage: "gearshape")
                }
            }
        }
        .customFont()
    }
}

struct CowriterView_Previews: PreviewProvider {
    
    static var previews: some View {
        CowriterView()
    }
}
