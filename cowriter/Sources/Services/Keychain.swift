//
//  APISecurity.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/04/23.
//

import Foundation
import Security

class Keychain {
    
    static func saveApiKey(apiKey: String) -> Bool {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.example.myapp.apikey",
            kSecAttrAccount as String: "myApiKey",
            kSecValueData as String: apiKey.data(using: .utf8)!,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            return updateApiKey(apiKey: apiKey)
        } else {
            return false
        }
    }
    
    static func updateApiKey(apiKey: String) -> Bool {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.example.myapp.apikey",
            kSecAttrAccount as String: "myApiKey"
        ]
        
        let attributesToUpdate: [String: Any] = [
            kSecValueData as String: apiKey.data(using: .utf8)!
        ]
        
        let status = SecItemUpdate(keychainQuery as CFDictionary, attributesToUpdate as CFDictionary)
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    static func getApiKey() -> String? {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.example.myapp.apikey",
            kSecAttrAccount as String: "myApiKey",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &result)
        if status == errSecSuccess {
            if let data = result as? Data,
               let apiKey = String(data: data, encoding: .utf8) {
                return apiKey
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
}
