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
        NSLocalizedString("_good_day", comment: ""),
        NSLocalizedString("_hi_there", comment: ""),
        NSLocalizedString("_hello", comment: ""),
        NSLocalizedString("_greetings", comment: ""),
        NSLocalizedString("_welcome", comment: "")
    ]
    
    private let greetings: [String] = [
        NSLocalizedString("_help_question_1", comment: ""),
        NSLocalizedString("_help_question_2", comment: ""),
        NSLocalizedString("_help_question_3", comment: ""),
        NSLocalizedString("_help_question_4", comment: ""),
        NSLocalizedString("_help_question_5", comment: "")
    ]

    private let lastGreetings: [String] = [
        NSLocalizedString("_get_started", comment: ""),
        NSLocalizedString("_writing_assistance", comment: ""),
        NSLocalizedString("_editing_proofreading_help", comment: ""),
        NSLocalizedString("_recipe_cooking_assistance", comment: ""),
        NSLocalizedString("_productivity_next_level", comment: "")
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
