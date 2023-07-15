//
//  Enums.swift
//  cowriter
//
//  Created by Aditya Cahyo on 06/05/23.
//

import Foundation

enum ChatRoleEnum: String, Codable {
    case user = "user"
    case system = "system"
    case assistant = "assistant"
}

enum MarkdownEnum: String, CaseIterable {
    case termsAndConditions, privacyPolicy, aboutUs
    
    var desc: String {
        switch self {
        case .termsAndConditions:
            return "_terms_and_conditions"
        case .privacyPolicy:
            return "_privacy_policy"
        case .aboutUs:
            return "_about_us"
        }
    }
    
    var link: String {
        switch self {
        case .termsAndConditions:
            return "https://bit.ly/cowriter-termsconditions"
        case .privacyPolicy:
            return "https://bit.ly/cowriter-privacypolicy"
        case .aboutUs:
            return "https://bit.ly/3BT09h9"
        }
    }
}

enum AppearanceMode: String, CaseIterable, Codable {
    case light, dark, system
    var id: Self { self }
    
    var icon: String {
        switch self {
        case .light:
            return "sun.min"
        case .dark:
            return "moon.circle"
        case .system:
            return "moon.stars"
        }
    }
}

enum PlanEnum: String, CaseIterable {
    case annual = "cowriter.pro.annual.v1"
    case monthly = "cowriter.pro.monthly.v1"
    
    var recurring: String {
        switch self {
        case .annual:
            return "_annual"
        case .monthly:
            return "_monthly"
        }
    }
    
    var desc: String {
        switch self {
        case .annual:
            return "_annual_desc"
        case .monthly:
            return "_monthly_desc"
        }
    }
    
}
