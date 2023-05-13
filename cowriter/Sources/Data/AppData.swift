//
//  AppData.swift
//  macro-team15
//
//  Created by Aditya Cahyo on 12/05/23.
//

import Foundation
import SwiftUI

class AppData: ObservableObject {
    @AppStorage(AppStorageKey.hasFirstLaunched.rawValue) var hasFirstLaunched: Bool = false
    @AppStorage(AppStorageKey.preferredColorScheme.rawValue) var preferredColorScheme: AppearanceMode = AppearanceMode.system
    @AppStorage(AppStorageKey.greetingViewIsAnimating.rawValue) var greetingViewIsAnimating: Bool = false
    
    static func setHasFirstLaunched(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: AppStorageKey.hasFirstLaunched.rawValue)
    }
    static func setGreetingViewIsAnimating(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: AppStorageKey.greetingViewIsAnimating.rawValue)
    }
}

enum AppStorageKey: String {
    case hasFirstLaunched
    case preferredColorScheme
    case greetingViewIsAnimating
}
