//
//  Enums.swift
//  cowriter
//
//  Created by Aditya Cahyo on 06/05/23.
//

import Foundation

enum PlanEnum: String {
    case annual, monthly
    
    var desc: String {
        switch self {
        case .annual:
            return "Rp82.500 / month, billed annualy"
        case .monthly:
            return "Rp99.000 / month after 1 week"
        }
    }
    
    var title: String {
        switch self {
        case .annual:
            return "Rp990.000"
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
