//
//  WelcomeVM.swift
//  swiftChat
//
//  Created by Aditya Cahyo on 18/05/23.
//

import Foundation
import SwiftUI

class WelcomeVM: ObservableObject {
    @Published var welcomeText: String?
    @Published var step: Int = -1
    
    private let welcomeSentences = [
        "I am Swift AI, your friendly and efficient personal to make your life easier by helping with tasks, answering questions, and providing solutions at lightning speed.",
        "I primarily support English, and understand and generate responses in other languages to some extent but quality and accuracy may vary."
    ]
    
    func isWelcomeTextMatching() -> Bool {
        if let text = welcomeText {
            return welcomeSentences.contains(text)
        }
        return false
    }
    
    func startNextStep() {
        if welcomeText == welcomeSentences[step] {
            step += 1
        }
    }
    
    func setupCompleted() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                AppData.setSetupCompleted(true)
            }
        }
    }
    
    func playWelcomeSentences() {
        welcomeText = nil
        guard step != welcomeSentences.count else {
            setupCompleted()
            return
        }
        
        let arrayWelcomeSentences = welcomeSentences[step].components(separatedBy: " ")
        arrayWelcomeSentences.enumerated().forEach { index, word in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1 + Double(index) * 0.2) {
                self.welcomeText = (self.welcomeText ?? "") + (index != 0 ? " " : "") + word
            }
        }
    }
}
