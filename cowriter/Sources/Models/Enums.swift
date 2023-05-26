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
            return "Terms and Conditions"
        case .privacyPolicy:
            return "Privacy Policy"
        case .aboutUs:
            return "About Us"
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
            return "annual"
        case .monthly:
            return "monthly"
        }
    }
    
    var desc: String {
        switch self {
        case .annual:
            return "/ month, billed annualy"
        case .monthly:
            return "/ month after 1 week"
        }
    }
    
    var title: String? {
        switch self {
        case .annual:
            return nil
        case .monthly:
            return "7 DAY FREE TRIAL"
        }
    }
    
}
