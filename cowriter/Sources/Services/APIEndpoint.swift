//
//  APIEndpoint.swift
//  swiftChat
//
//  Created by Aditya Cahyo on 05/04/23.
//

import Foundation

struct APIEndpoint {
    static let baseURL = URL(string: "https://api.openai.com/v1")!
    
    static let chatCompletions = baseURL.appendingPathComponent("/chat/completions")
    static let completions = baseURL.appendingPathComponent("/completions")
}
