//
//  Utils.swift
//  cowriter
//
//  Created by Aditya Cahyo on 06/04/23.
//

import Foundation
import NaturalLanguage
import GPT3_Tokenizer

class Utils {
    static let languageRecognizer = NLLanguageRecognizer()
    
    static func detectLanguage(for string: String) -> String {
        languageRecognizer.processString(string)
        
        guard let languageCode = languageRecognizer.dominantLanguage?.rawValue,
              let localizedString = Locale(identifier: languageCode).localizedString(forLanguageCode: languageCode) else {
            return ""
        }
        
        return localizedString
    }
    
    static func getLocaleFromText(_ text: String) -> Locale {
        languageRecognizer.processString(text)
        
        guard let languageCode = languageRecognizer.dominantLanguage?.rawValue else {
            return Locale.current
        }
        
        return Locale(identifier: languageCode)
    }
    
    static func toDictionary(_ any: Any) -> [String: Any] {
        var dictionary: [String: Any] = [:]
        let mirror = Mirror(reflecting: any)
        
        for child in mirror.children {
            guard let key = child.label else { continue }
            
            if let value = child.value as? AnyHashable {
                dictionary[key] = value
            } else if let value = child.value as? [Any] {
                dictionary[key] = value.map { toDictionary($0) }
            } else {
                dictionary[key] = toDictionary(child.value)
            }
        }
        
        return dictionary
    }
    
    static func removeNewlineAtBeginning(_ str: String) -> String {
        var result = str
        while result.first == "\n" {
            result.removeFirst()
        }
        return result
    }
    
    static func tokenizer(_ text: String) -> Int {
        let gpt3Tokenizer = GPT3Tokenizer()
        return gpt3Tokenizer.encoder.enconde(text: text).count
    }
    
}

