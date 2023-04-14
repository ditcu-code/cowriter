//
//  PromptHint.swift
//  cowriter
//
//  Created by Aditya Cahyo on 14/04/23.
//

import SwiftUI

func hasTrailingDot(_ str: String) -> Bool {
    if let lastChar = str.last {
        return lastChar == "."
    } else {
        return false
    }
}

struct PromptHint: View {
    @StateObject var vm: CowriterVM
    
    var prompts: [String] = [
        "Create an outline for a project brief",
        "Write an essay about Elon Musk",
        "Create an instagram caption about..",
        "Create interview questions for mobile developer",
        "Write an email to.."
    ]
    
    func hasTrailingDot(_ str: String) -> Bool {
        if let lastChar = str.last {
            return lastChar == "."
        } else {
            return false
        }
    }
    
    var body: some View {
        
        VStack(spacing: 5) {
            ForEach(prompts, id: \.self) {prompt in
                Button {
                    vm.textPrompt = prompt
                } label: {
                    HStack() {
                        Circle()
                            .frame(width: 9)
                            .foregroundColor(hasTrailingDot(prompt) ? .yellow : .orange)
                        Text(prompt)
                            .font(.footnote)
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                            .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y:1)
                            .frame(height: 23)
                    )
                }.customFont()
            }
        }
    }
}

//struct PromptHint_Previews: PreviewProvider {
//    static var previews: some View {
//        PromptHint()
//    }
//}
