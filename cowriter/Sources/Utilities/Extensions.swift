//
//  Extensions.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import SwiftUI
import GPT3_Tokenizer

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

extension Color {
    static let defaultFont = Color("DefaultFont")
    static let darkGrayFont = Color("DarkGrayFont")
    static let grayFont = Color("GrayFont")
    static let answerBubble = Color("AnswerBubble")
}

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        )
    }
    
    static var upAndLeft: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom),
            removal: .move(edge: .trailing)
        )
    }
}

extension String {
    func removeNewLines(_ delimiter: String = "") -> String {
        self.replacingOccurrences(of: "\n", with: delimiter)
    }
    
    func containsOneWord() -> Bool {
        let components = self.components(separatedBy: .whitespaces)
        return components.count == 1
    }
    
    func tokenize() -> Int {
        let gpt3Tokenizer = GPT3Tokenizer()
        return gpt3Tokenizer.encoder.enconde(text: self).count
    }
    
    func removeNewlineAtBeginning() -> String {
        var result = self
        while result.first == "\n" {
            result.removeFirst()
        }
        return result
    }
    
    var firstWord: String? {
        let components = self.components(separatedBy: CharacterSet.whitespaces)
        return components.first
    }
    
}

extension Date {
    func toMonthYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self)
    }
    
    func countDays(to endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self, to: endDate)
        
        guard let days = components.day else {
            return 0 // Could not calculate the number of days
        }
        
        return abs(days) // Return the absolute value of days
    }
    
    func isPast() -> Bool {
        let currentDate = Date()
        return self < currentDate
    }
    
}

extension View {
    func gillFont(_ size: CGFloat = 17, _ color: Color = Color.darkGrayFont) -> some View {
        return self.modifier(FontModifier(font: Font.custom("Gill Sans", size: size, relativeTo: .body), color: color))
    }
    func onFirstAppear(_ action: @escaping () -> ()) -> some View {
        modifier(FirstAppear(action: action))
    }
}

fileprivate struct FontModifier: ViewModifier {
    var font: Font
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
    }
}

fileprivate struct FirstAppear: ViewModifier {
    let action: () -> ()
    
    // Use this to only fire your block one time
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        // And then, track it here
        content.onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            action()
        }
    }
}
