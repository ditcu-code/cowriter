//
//  APISecurity.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/04/23.
//

import Foundation
import Security

class Keychain {
    static func saveSwift(title: String, completion: @escaping (Bool) -> Void) {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.ditcu.cowriter.key",
            kSecAttrAccount as String: "mySwift",
            kSecValueData as String: title.data(using: .utf8)!,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
            kSecAttrSynchronizable as String: kCFBooleanTrue!
        ]
        
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        if status == errSecSuccess {
            completion(true)
        } else if status == errSecDuplicateItem {
            updateSwift(title: title) { result in
                completion(result)
            }
        } else {
            completion(false)
        }
    }
    
    static func updateSwift(title: String, completion: @escaping (Bool) -> Void) {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.ditcu.cowriter.key",
            kSecAttrAccount as String: "mySwift"
        ]
        
        let attributesToUpdate: [String: Any] = [
            kSecValueData as String: title.data(using: .utf8)!
        ]
        
        let status = SecItemUpdate(keychainQuery as CFDictionary, attributesToUpdate as CFDictionary)
        if status == errSecSuccess {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    static func getSwift() -> String? {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.ditcu.cowriter.key",
            kSecAttrAccount as String: "mySwift",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrSynchronizable as String: kCFBooleanTrue!
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &result)
        if status == errSecSuccess {
            if let data = result as? Data,
               let title = String(data: data, encoding: .utf8) {
                return title
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
