//
//  WelcomeService.swift
//  swiftChat
//
//  Created by Aditya Cahyo on 18/05/23.
//

import CloudKit

class WelcomeService {
    private let context = PersistenceController.viewContext
    
    func createNewUser() {
        let newUser = User(context: self.context)
        newUser.joinDate = Date()
        
        CKContainer.default().fetchUserRecordID(completionHandler: { (recordId, error) in
            if let name = recordId?.recordName {
                print("iCloud ID: " + name)
                newUser.id = name
            }
            else if let error = error {
                print(error.localizedDescription)
                newUser.id = UUID().uuidString
            }
            PersistenceController.save()
        })
    }
}
