//
//  ChatCompletionsModel.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/04/23.
//

import Foundation

enum GPTModel: String, Codable {
    case threePointFive = "gpt-3.5-turbo"
    case curie = "text-curie-001"
}

enum ChatRole: String, Codable   {
    case user = "user"
    case system = "system"
    case assistant = "assistant"
}

struct ChatMessage: Codable {
    var role, content: String
}

struct ChatRequest {
    var model: String = GPTModel.threePointFive.rawValue
    var messages: [ChatMessage]
    var temperature: Double = 0.2
}

struct CompletionRequest {
    var model: String = GPTModel.curie.rawValue
    var prompt: String
    var temperature: Double = 0
    var max_tokens: Int = 1000
}

struct ChatUsage: Codable {
    var promptTokens, completionTokens, totalTokens: Int
}

struct ChatChoicesChat: Codable {
    var message: ChatMessage
    var finishReason: String
    var index: Int
}

struct ChatChoicesCompletion: Codable {
    var text: String
    var logprobs: Int?
    var finishReason: String?
    var index: Int
}

class ChatResponseChat: Codable {
    var id, object, model: String
    var created: Int
    var usage: ChatUsage
    var choices: [ChatChoicesChat]
}

class ChatResponseCompletion: Codable {
    var id, object, model: String
    var created: Int
    var usage: ChatUsage
    var choices: [ChatChoicesCompletion]
}
