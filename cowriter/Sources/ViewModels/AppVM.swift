//
//  AppVM.swift
//  cowriter
//
//  Created by Aditya Cahyo on 14/05/23.
//

import Foundation
import CloudKit

class AppVM: ObservableObject {
    private let context = PersistenceController.viewContext
    private let appData = AppData()
    private let cloudkitData = PublicDataCloudKit()
    
    func createNewUser() {
        User.isZero(in: context) { isZero in
            if isZero {
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
            } else {
                print("User already available")
            }
        }
    }
    
    func initialCheck() {
        createNewUser()
        cloudkitData.fetchMyObjects()
    }
}
