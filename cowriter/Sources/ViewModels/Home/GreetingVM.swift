//
//  GreetingVM.swift
//  cowriter
//
//  Created by Aditya Cahyo on 18/05/23.
//

import Foundation
import SwiftUI

class GreetingVM: ObservableObject {
    @Published var greeting1: String?
    @Published var greeting2: String?
    
    private let firstGreetings: [String] = [
        "Good day!",
        "Hi there!",
        "Hello! 👋🏼",
        "Greetings!",
        "Welcome!"
    ]
    
    private let greetings: [String] = [
        "How can I assist you with your writing today?",
//        "Your pair programming here",
        "Need any help with editing or proofreading your writing?",
        "Need any recipe ideas or cooking tips?",
//        "Want to take a moment to reflect on your personal growth?",
        "Ready to take your productivity to the next level?"
    ]
    
    private let lastGreetings: [String] = [
        "Is there anything I can help you with?",
        "What can I do for you today?",
        "What brings you here today?",
//        "Is there anything you'd like to chat about?",
        "What can I help?",
        "What do you need assistance with?",
        "Let's get started!"
    ]
    
    func startGreetingsAnimation(profileName: String?) {
        guard greeting1 == nil else { return }
        
        var finalFirstGreetings = firstGreetings
        if let name = profileName {
            finalFirstGreetings.append("Hi, \(name)!")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.greeting1 = finalFirstGreetings.randomElement()
        }
        
        var randomGreetings: [String] = Array(Set(greetings.shuffled().prefix(2)))
        randomGreetings.append(lastGreetings.randomElement()!)
        
        randomGreetings.enumerated().forEach { index, greeting in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3 + Double(index * 5)) {
                self.greeting2 = greeting
                if randomGreetings.last != greeting {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
                        self.greeting2 = nil
                    }
                }
            }
        }
    }
}

