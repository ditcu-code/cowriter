//
//  CowriterView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import SwiftUI

struct CowriterView: View {
    @State var text: String = ""
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.2).ignoresSafeArea()
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20.0).fill(.background).frame(height: 38)
                        HStack {
                            TextField("Tell cowriter to...", text: $text)
                                .font(.custom("Gill Sans", size: 17, relativeTo: .headline))
                                .padding(.horizontal)
                                .onSubmit {
                                    print(text)
                                }
                            SendButton().padding(.horizontal, 5)
                        }
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
