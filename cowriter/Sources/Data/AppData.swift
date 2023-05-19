//
//  AppData.swift
//  macro-team15
//
//  Created by Aditya Cahyo on 12/05/23.
//

import Foundation
import SwiftUI

class AppData: ObservableObject {
    static let shared = AppData()
    @AppStorage(AppStorageKey.setupCompleted.rawValue) var setupCompleted: Bool = false
    @AppStorage(AppStorageKey.reachedLimit.rawValue) var reachedLimit: Bool = false
    @AppStorage(AppStorageKey.titleModifiedDate.rawValue) var titleModifiedDate: String = ""
    @AppStorage(AppStorageKey.preferredColorScheme.rawValue) var preferredColorScheme: AppearanceMode = AppearanceMode.system
    
    static func setSetupCompleted(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: AppStorageKey.setupCompleted.rawValue)
    }
    static func setReachedLimit(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: AppStorageKey.reachedLimit.rawValue)
    }
    static func setTitleModifiedDate(_ value: Date) {
        UserDefaults.standard.set(value.description, forKey: AppStorageKey.titleModifiedDate.rawValue)
    }
}

enum AppStorageKey: String {
    case setupCompleted
    case reachedLimit
    case titleModifiedDate
    case preferredColorScheme
}
