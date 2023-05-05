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

    var body: some View {
        TabView {
            CowriterView()
                .tabItem {
                    Label("Cowriter", systemImage: "timelapse")
                }
            
            AsisstView()
                .tabItem {
                    Label("Assist", systemImage: "rectangle.and.pencil.and.ellipsis")
                }
            
            GrammarView()
                .tabItem {
                    Label("Grammar", systemImage: "checkmark.circle")
                }
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
        }.foregroundColor(.orange)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
