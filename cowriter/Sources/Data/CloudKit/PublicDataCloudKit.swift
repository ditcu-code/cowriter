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
    private let user: User?
    
    init() {
        container = CKContainer.default()
        database = container.publicCloudDatabase
        user = User.fetchFirstUser()
    }
    
    func createUsage() {
        if let userId = user?.id, let totalUsage = user?.totalUsage {
            let record = CKRecord(recordType: "UserUsageType", recordID: CKRecord.ID(recordName: "Usage_Of_\(userId)"))
            record.setValue(NSNumber(value: totalUsage), forKey: "totalUsage")
            database.save(record) { record, saveError in
                if let saveError = saveError {
                    // Handle the save error
                    print("Error saving record: \(saveError.localizedDescription)")
                } else {
                    // The record was saved successfully
                    print("Record saved successfully!")
                }
            }
        }
    }
    
    //    func modifyUsage(_ usage: Int = 0) {
    //        if let userId = user?.id {
    //            database.fetch(withRecordID: CKRecord.ID(recordName: "Usage-of-\(userId)")) { record, error in
    //                if let error = error {
    //                    // Handle the error
    ////                    self.createUsage()
    //                    print("Error fetching record: \(error.localizedDescription)")
    //                } else if let record = record {
    //                    // Modify the desired fields or values of the record
    //                    let lastGiven = record["lastGiven"]
    //                    let prevUsage = record["totalUsage"] as? Int ?? 0
    //                    record.setValue(prevUsage + usage, forKey: "")
    //
    //                    // Save the modified record back to CloudKit
    //                    self.database.save(record) { (savedRecord, saveError) in
    //                        if let saveError = saveError {
    //                            // Handle the save error
    //                            print("Error saving record: \(saveError.localizedDescription)")
    //                        } else {
    //                            // The record was saved successfully
    //                            print("Record saved successfully!")
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
    
//    func haveReachedLimit() {
        //        self.createUsage()
        //        if let user = user {
        //            let dailyQuota = 500
        //            let maxDailyUsage = 2000
        //            let days = user.joinDate?.countDays(to: Date()) ?? 0
        //            let totalQuota = dailyQuota * (days + 1) // 5000
        //            //
        //            let quota = totalQuota - Int(user.totalUsage) // 4500
        //
        //            let quotaGiven = quota > maxDailyUsage ? maxDailyUsage : quota ///
        //            print("quota", quota, user)
        //        }
//    }
    
    func fetchMyObjects() {
        let recordID = CKRecord.ID(recordName: "swiftKey")
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
