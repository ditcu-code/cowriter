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
    case annual = "pro.annual.sub.test"
    case monthly = "pro.monthly.sub.test"
    
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
    
    var discount: String? {
        switch self {
        case .annual:
            return "Rp1.188.000"
        case .monthly:
            return nil
        }
    }
}
