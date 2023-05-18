//
//  ProfileViewVM.swift
//  swiftChat
//
//  Created by Aditya Cahyo on 14/05/23.
//

import Foundation

class ProfileManager: ObservableObject {
    private var context = PersistenceController.viewContext
    
    @Published var user: User?
    @Published var name: String = ""
    @Published var isProfileTap = false
    
    init() {
        getUser()
    }
    
    func getUser() {
        if let result = User.fetchFirstUser() {
            user = result
            guard let user = user else { return }
            name = user.wrappedName
        }
    }
    
    func changeName() {
        guard let user = user else { return }
        user.name = name
        
        do {
            try context.save()
            isProfileTap.toggle()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}
