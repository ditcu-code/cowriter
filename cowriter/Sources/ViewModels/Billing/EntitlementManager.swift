//
//  EntitlementManager.swift
//  cowriter
//
//  Created by Aditya Cahyo on 09/05/23.
//

import Foundation
import Combine

class EntitlementManager: ObservableObject { /// can be shared across extensions
    static let userDefaults = UserDefaults(suiteName: "group.ditcu.cowriter")!

    @Published var hasPro: Bool {
        didSet {
            EntitlementManager.userDefaults.set(hasPro, forKey: "hasPro")
        }
    }

    init() {
        self.hasPro = EntitlementManager.userDefaults.bool(forKey: "hasPro")
    }
}
