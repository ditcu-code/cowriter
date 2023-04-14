//
//  ChatCompletionsModel.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/04/23.
//

import Foundation

enum GPTModelType: String, Codable {
    case threePointFive = "gpt-3.5-turbo"
    case curie = "text-curie-001"
}

struct CompletionRequestType {
    var model: String = GPTModelType.curie.rawValue
    var prompt: String
    var temperature: Double = 0
    var max_tokens: Int = 1000
}

struct CompletionChoicesType: Codable {
    var text: String
    var logprobs: Int?
    var finishReason: String?
    var index: Int
}

class CompletionResponseType: Codable {
    var id, object, model: String
    var created: Int
    var usage: ChatUsageType
    var choices: [CompletionChoicesType]
}
