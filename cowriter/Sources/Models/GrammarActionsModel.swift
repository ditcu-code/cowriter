//
//  GrammarActionsModel.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/04/23.
//

import Foundation

struct UserText: Codable {
    let id: UUID
    let text: String
    let date: Date
    let score: Int
    let prevID: UUID?
}
