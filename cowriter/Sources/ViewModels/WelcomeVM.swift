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
    
    private let cloudKitService = PublicCloudKitService()
    private let welcomeService = WelcomeService()
    
    private let welcomeSentences = [
        "I am Swift AI, your friendly and efficient personal to make your life easier by helping with tasks, answering questions, and providing solutions at lightning speed.",
        "I primarily support English, and understand and generate responses in other languages to some extent but quality and accuracy may vary."
    ]
    
    // triggered onAppear
    func firstAppear() {
        step == -1 ? step += 1 : nil
    }
    
    func isWelcomeTextMatching() -> Bool {
        if let text = welcomeText {
            return welcomeSentences.contains(text)
        }
        return false
    }
    
    // triggered onTapGesture
    func startNextStep() {
        if welcomeText == welcomeSentences[step] {
            step += 1
            
            User.isEmpty() { emptyUser in
                if emptyUser {
                    self.welcomeService.createNewUser()
                } else {
                    print("User already available!")
                }
            }
        }
    }
    
    // triggered when all welcome message shown
    func setupCompleted() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                AppData.setSetupCompleted(true)
            }
        }
    }
    
    // triggered onChange step
    func playWelcomeSentences() {
        welcomeText = nil
        guard step != welcomeSentences.count else {
            self.setupCompleted()
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
