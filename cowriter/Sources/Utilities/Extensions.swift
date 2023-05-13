//
//  Extensions.swift
//  cowriter
//
//  Created by Aditya Cahyo on 12/04/23.
//

import Foundation
import SwiftUI
import GPT3_Tokenizer
import NaturalLanguage

fileprivate struct FontModifier: ViewModifier {
    var font: Font
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
    }
}

extension View {
    func customFont(_ size: CGFloat = 17, _ color: Color = Color.darkGrayFont) -> some View {
            return self.modifier(FontModifier(font: Font.custom("Gill Sans", size: size, relativeTo: .body), color: color))
    }
}

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
    
    func containsOnlyOneWord() -> Bool {
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
    
    func detectLanguage() -> String {
        let detector = NLLanguageRecognizer()
        detector.processString(self)
        
        guard let languageCode = detector.dominantLanguage?.rawValue,
              let localizedString = Locale(identifier: languageCode).localizedString(forLanguageCode: languageCode) else {
            return ""
        }
        
        return localizedString
    }
    
    func getLocaleFromText() -> Locale {
        let detector = NLLanguageRecognizer()
        detector.processString(self)
        
        guard let languageCode = detector.dominantLanguage?.rawValue else {
            return Locale.current
        }
        
        return Locale(identifier: languageCode)
    }
}
