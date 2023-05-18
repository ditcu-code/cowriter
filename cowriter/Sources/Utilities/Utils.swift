//
//  Utils.swift
//  swiftChat
//
//  Created by Aditya Cahyo on 06/04/23.
//

import Foundation
import NaturalLanguage
import GPT3_Tokenizer

class Utils {
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
}

