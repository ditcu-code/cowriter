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
    
    private let usageRecordType: String = "UserUsageType"
    
    init() {
        container = CKContainer.default()
        database = container.publicCloudDatabase
    }
    
    func getRecordName(userId: String) -> String {
        return "Usage_Of_\(userId)"
    }
    
    func updateUsage(user: User) async {
        do {
            let record = try await database.record(for: CKRecord.ID(recordName: getRecordName(userId: user.wrappedId)))
            // Modify the desired fields or values of the record
            let prevUsage = record["totalUsage"] as? Int ?? 0
            let lastGivenDate = record["givenDate"] as? Date ?? record.modificationDate ?? Date()
            let givenQuota = record["givenQuota"] as? Int ?? 0
            
            let quotaToGive = quota(user: user, lastGivenDate: lastGivenDate)
            
            if lastGivenDate.countDays(to: Date()) >= 1 {
                record.setValue(Date(), forKey: "givenDate")
                record.setValue(prevUsage + quotaToGive, forKey: "givenQuota")
            }
            record.setValue(user.wrappedTotalUsage, forKey: "totalUsage")
            
            appData.setReachedLimit(user.wrappedTotalUsage > givenQuota)
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
            await self.createUsage(user)
        }
    }
    
    func createUsage(_ user: User) async {
        let record = CKRecord(recordType: usageRecordType, recordID: CKRecord.ID(recordName: getRecordName(userId: user.wrappedId)))
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
    
    func quota(user: User, lastGivenDate: Date) -> Int {// besok
        guard lastGivenDate.isPast() else {
            return 0
        }
        let dailyQuota = 500
        let maxDailyUsage = 1500
        let days = user.wrappedJoinDate.countDays(to: Date())
        let totalQuota = dailyQuota * (days + 1) // 5000
        let quota = totalQuota - Int(user.wrappedTotalUsage) // 4500
        let quotaGiven = quota > maxDailyUsage ? maxDailyUsage : quota

        return quotaGiven
    }
    
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
