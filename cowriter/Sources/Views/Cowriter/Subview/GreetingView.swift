//
//  GreetingView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 08/05/23.
//

import SwiftUI

struct GreetingView: View {
    @State private var greeting1: String? = nil
    @State private var greeting2: String? = nil
    @ObservedObject var appData = AppData()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                if let unwrappedText: String = greeting1 {
                    Text(unwrappedText).bold()
                        .font(Font.system(.title3, design: .serif))
                        .foregroundColor(.defaultFont)
                        .transition(.moveAndFade)
                }
                
                if let unwrappedText: String = greeting2 {
                    Text(unwrappedText).bold()
                        .font(Font.system(.title2, design: .serif))
                        .foregroundColor(.grayFont)
                        .transition(.moveAndFade)
                }
                Spacer()
            }.frame(maxHeight: 130)
            Spacer()
        }
        .padding()
        .padding(.horizontal)
        .animation(.interpolatingSpring(stiffness: 60, damping: 12), value: [greeting1, greeting2])
        .onAppear {
            startGreetingsAnimation()
        }
    }
    
    private let firstGreetings: [String] = [
        "Good day!",
        "Hi there!",
        "Hello!",
        "Greetings!",
        "Hi! 👋🏼",
        "Welcome!"
    ]
    
    private let greetings: [String] = [
        "How can I assist you with your writing today?",
        "Your pair programming here",
        "Need any help with editing or proofreading your writing?",
        "Need any recipe ideas or cooking tips?",
        "Want to take a moment to reflect on your personal growth?",
        "Ready to take your productivity to the next level?"
    ]
    
    private let lastGreetings: [String] = [
        "Is there anything I can help you with?",
        "What can I do for you today?",
        "What brings you here today?",
        "Is there anything you'd like to chat about?",
        "What can I help?",
        "What do you need assistance with?",
        "Let's get started!"
    ]
    
    private func startGreetingsAnimation() {
        guard !appData.greetingViewIsAnimating else { return }
        AppData.setGreetingViewIsAnimating(true)
        
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            greeting1 = firstGreetings.randomElement()!
        }
        
        var randomGreetings: [String] = Array(Set(greetings.shuffled().prefix(2)))
        randomGreetings.append(lastGreetings.randomElement()!)
        
        randomGreetings.enumerated().forEach { index, greeting in
            dispatchGroup.enter()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3 + Double(index * 5) ) {
                /// 3 10 17 24
                greeting2 = greeting
                if randomGreetings.last != greeting {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
                        greeting2 = nil
                        dispatchGroup.leave()
                    }
                } else {
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            AppData.setGreetingViewIsAnimating(false)
        }
    }
}

struct GreetingView_Previews: PreviewProvider {
    static var previews: some View {
        GreetingView()
    }
}
