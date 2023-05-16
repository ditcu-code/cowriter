//
//  PublicDataCloudKit.swift
//  swiftChat
//
//  Created by Aditya Cahyo on 16/05/23.
//

import Foundation
import CloudKit

class PublicDataCloudKit {
    private let container: CKContainer
    private let database: CKDatabase
    private let appData = AppData.self
    
    init() {
        container = CKContainer.default()
        database = container.publicCloudDatabase
    }
    
    func fetchMyObjects() {
        let recordID = CKRecord.ID(recordName: "9A27C2FD-0169-4A5B-ABD5-E132D77489C9")
        database.fetch(withRecordID: recordID) { record, error in
            guard let record = record, let modificationDate = record.modificationDate else {
                print("Error fetch")
                return
            }
            
            let title = record["title"] as? String ?? ""
            
            if self.appData.shared.titleModifiedDate != modificationDate.description {
                Keychain.saveSwift(title: title) { result in
                    self.appData.setTitleModifiedDate(modificationDate)
                    self.appData.setSetupCompleted(result)
                }
            }
        }
    }
    
}
