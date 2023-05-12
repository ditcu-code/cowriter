//
//  AppData.swift
//  macro-team15
//
//  Created by Aditya Cahyo on 12/05/23.
//

import Foundation
import SwiftUI

class AppData: ObservableObject {
    @AppStorage(AppStorageEnum.hasFirstLaunched.rawValue) var hasFirstLaunched: Bool = false
    @AppStorage(AppStorageEnum.preferredColorScheme.rawValue) var preferredColorScheme: AppearanceMode = AppearanceMode.system
    
    static func setHasFirstLaunched(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: AppStorageEnum.hasFirstLaunched.rawValue)
    }
    static func setPreferredColorScheme(_ value: AppearanceMode) {
        UserDefaults.standard.set(value, forKey: AppStorageEnum.preferredColorScheme.rawValue)
    }
}

enum AppStorageEnum: String {
    case hasFirstLaunched
    case preferredColorScheme
}
