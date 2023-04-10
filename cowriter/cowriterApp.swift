//
//  cowriterApp.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/04/23.
//

import SwiftUI

@main
struct cowriterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
            GrammarView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
