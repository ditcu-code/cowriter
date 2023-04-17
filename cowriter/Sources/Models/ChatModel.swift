//
//  ChatModel.swift
//  cowriter
//
//  Created by Aditya Cahyo on 15/04/23.
//

import Foundation

enum ChatRoleEnum: String, Codable   {
    case user = "user"
    case system = "system"
    case assistant = "assistant"
}

struct ChatMessageType: Codable {
    var role, content: String
}

struct ChatRequestType {
    var model: String = GPTModelType.threePointFive.rawValue
    var messages: [ChatMessageType]
    var temperature: Double = 0.2
}

struct ChatUsageType: Codable {
    var promptTokens, completionTokens, totalTokens: Int
}

struct ChatChoicesType: Codable {
    var message: ChatMessageType
    var finishReason: String
    var index: Int
}

class ChatResponseChatType: Codable {
    var id, object, model: String
    var created: Int
    var usage: ChatUsageType
    var choices: [ChatChoicesType]
}
