//
//  GreetingView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 08/05/23.
//

import SwiftUI

struct GreetingView: View {
    @State private var text1: String? = nil
    @State private var text2: String? = nil
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                if let unwrappedText: String = text1 {
                    Text(unwrappedText).bold()
                        .transition(.moveAndFade)
                        .font(Font.system(.title3, design: .serif))
                        .foregroundColor(.grayFont)
                }
                
                if let unwrappedText: String = text2 {
                    Text(unwrappedText).bold()
                        .transition(.moveAndFade)
                        .font(Font.system(.title2, design: .serif))
                        .foregroundColor(.darkGrayFont)
                }
            }
            Spacer()
        }
        .padding()
        .padding(.horizontal)
        .animation(.interpolatingSpring(stiffness: 50, damping: 15), value: [text1, text2])
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                text1 = "Hello!"
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                text2 = "How can I assist you with your writing today?"
            }
        }
    }
}

struct GreetingView_Previews: PreviewProvider {
    static var previews: some View {
        GreetingView()
    }
}
