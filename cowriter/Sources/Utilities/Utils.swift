//
//  Utils.swift
//  cowriter
//
//  Created by Aditya Cahyo on 06/04/23.
//

import Foundation
import NaturalLanguage

class Utils {
    
    static func detectLanguage(for string: String) -> String {
        let detector = NLLanguageRecognizer()
        detector.processString(string)
        
        guard let languageCode = detector.dominantLanguage?.rawValue else {
            return ""
        }
        
        let locale = Locale(identifier: languageCode)
        return locale.localizedString(forLanguageCode: languageCode) ?? ""
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
    

}

