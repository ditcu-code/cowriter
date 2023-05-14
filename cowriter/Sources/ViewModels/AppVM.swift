//
//  AppVM.swift
//  cowriter
//
//  Created by Aditya Cahyo on 14/05/23.
//

import Foundation

class AppVM: ObservableObject {
    private let context = PersistenceController.viewContext
    
    func createNewUser() {
        let newUser = User(context: context)
        newUser.joinDate = Date()
        newUser.id = UUID()
        
        PersistenceController.save()
    }
}
