//
//  PromptHint.swift
//  cowriter
//
//  Created by Aditya Cahyo on 14/04/23.
//

import SwiftUI

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
                            .frame(width: 9, height: 9)
                            .foregroundColor(hasTrailingDot(prompt) ? .yellow : .orange)
                        Text(prompt).customFont(14, .grayFont)
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.background)
                            .frame(height: 23)
                    )
                }
            }
        }
    }
}

//struct PromptHint_Previews: PreviewProvider {
//    static var previews: some View {
//        PromptHint()
//    }
//}
