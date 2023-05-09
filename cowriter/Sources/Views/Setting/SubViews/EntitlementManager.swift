//
//  EntitlementManager.swift
//  cowriter
//
//  Created by Aditya Cahyo on 09/05/23.
//

import SwiftUI

class EntitlementManager: ObservableObject {
    static let userDefaults = UserDefaults(suiteName: "group.ditcu.cowriter")!
    
    @AppStorage("hasPro", store: userDefaults)
    var hasPro: Bool = false
}
