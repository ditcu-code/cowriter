//
//  CowriterModel.swift
//  cowriter
//
//  Created by Aditya Cahyo on 17/04/23.
//

import Foundation

struct Prompts: Identifiable, Equatable {
    var id: UUID = UUID()
    var prompt, result: String
}
