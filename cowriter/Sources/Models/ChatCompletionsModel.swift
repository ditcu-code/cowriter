//
//  ChatCompletionsModel.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/04/23.
//

import Foundation

enum ChatRole: String, Codable   {
    case user = "user"
    case system = "system"
    case assistant = "assistant"
}

struct ChatMessage: Codable {
    var role: String
    var content: String
}

struct ChatCompletionReq {
    var model = "gpt-3.5-turbo-0301"
    var messages: [ChatMessage]
    var temperature: Double = 0.2
}

struct ChatUsage: Codable {
    var promptTokens: Int
    var completionTokens: Int
    var totalTokens: Int
}

struct ChatChoices: Codable {
    var message: ChatMessage
    var finishReason: String
    var index: Int
}

struct ChatResponse: Codable {
    var id: String
    var object: String
    var created: Int
    var model: String
    var usage: ChatUsage
    var choices: [ChatChoices]
}
