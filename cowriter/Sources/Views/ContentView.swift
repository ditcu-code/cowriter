//
//  ContentView.swift
//  cowriter
//
//  Created by Aditya Cahyo on 05/04/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var appData = AppData()
    
    var body: some View {
        CowriterView().preferredColorScheme(selectedColorScheme)
    }
    
    private var selectedColorScheme: ColorScheme? {
        switch appData.preferredColorScheme {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
