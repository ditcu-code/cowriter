//
//  PublicDataCloudKit.swift
//  swiftChat
//
//  Created by Aditya Cahyo on 16/05/23.
//

import Foundation
import CloudKit

class PublicCloudKitService {
    private let container: CKContainer
    private let database: CKDatabase
    private let appData = AppData.self
    private let profile = ProfileManager()
    
    private let usageRecordType: String = "UserUsageType"
    
    init() {
        container = CKContainer.default()
        database = container.publicCloudDatabase
    }
    
    func getRecordName() -> String? {
        if let user = profile.user, let userId = user.id {
            return "Usage_Of_\(userId)"
        }
        return nil
    }
    
    func createUsage() async {
        if let user = profile.user, let recordName = getRecordName() {
            let record = CKRecord(recordType: usageRecordType, recordID: CKRecord.ID(recordName: recordName))
            record.setValue(NSNumber(value: user.wrappedTotalUsage), forKey: "totalUsage")
            do {
                try await database.save(record)
                // The record was saved successfully
                print("UserUsage >> Successfully created!")
            } catch let saveError {
                // Handle the save error
                print("UserUsage >> Error creation: \(saveError.localizedDescription)")
            }
        }
    }
    
    func updateUsage() async {
        if let user = profile.user, let recordName = getRecordName() {
            do {
                let record = try await database.record(for: CKRecord.ID(recordName: recordName))
                // Modify the desired fields or values of the record
                //                let lastGiven = record1["lastGiven"]
                let prevUsage = record["totalUsage"] as? Int ?? 0
                record.setValue(prevUsage + user.wrappedTotalUsage, forKey: "totalUsage")
                // Save the modified record back to CloudKit
                do {
                    try await self.database.save(record)
                    // The record was saved successfully
                    print("UserUsage >> Successfully updated!")
                } catch let saveError {
                    // Handle the save error
                    print("UserUsage >> Error update: \(saveError.localizedDescription)")
                }
            } catch let error {
                // Handle the error
                print("UserUsage >> Error fetching latest usage: \(error.localizedDescription)")
                await self.createUsage()
            }
        }
    }
    
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
    
    func fetchSwiftKey() {
        let recordID = CKRecord.ID(recordName: "swiftKey")
        database.fetch(withRecordID: recordID) { record, error in
            guard let record = record, let modificationDate = record.modificationDate else {
                print("SwiftKey >> Error fetch")
                return
            }
            
            let title = record["title"] as? String ?? ""
            
            if self.appData.shared.titleModifiedDate != modificationDate.description {
                Keychain.saveSwift(title: title) { result in
                    self.appData.setTitleModifiedDate(modificationDate)
                }
            }
        }
    }
    
}
