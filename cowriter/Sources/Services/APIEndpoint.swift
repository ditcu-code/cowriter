//
//  APIEndpoint.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/04/23.
//

import Foundation

struct APIEndpoint {
    static let baseURL = URL(string: "https://api.openai.com/v1")!
    
    static let chatCompletions = baseURL.appendingPathComponent("/chat/completions")
}
