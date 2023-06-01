//
//  PublicDataCloudKit.swift
//  cowriter
//
//  Created by Aditya Cahyo on 16/05/23.
//

import Foundation
import CloudKit

class PublicCloudKitService {
    private let container: CKContainer
    private let database: CKDatabase
    private let appData = AppData.self
    
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
            let prevUsage = record[UserUsageKeys.totalUsage.rawValue] as? Int ?? 0
            let lastGivenDate = record[UserUsageKeys.givenDate.rawValue] as? Date ?? record.modificationDate ?? Date()
            let givenQuota = record[UserUsageKeys.givenQuota.rawValue] as? Int ?? 0
            
            let quotaToGive = quota(user: user, lastGivenDate: lastGivenDate)
            
            if lastGivenDate.countDays(to: Date()) >= 1 {
                record.setValue(Date(), forKey: UserUsageKeys.givenDate.rawValue)
                record.setValue(prevUsage + quotaToGive, forKey: UserUsageKeys.givenQuota.rawValue)
            }
            record.setValue(user.wrappedTotalUsage, forKey: UserUsageKeys.totalUsage.rawValue)
            
            appData.setReachedLimit(user.wrappedTotalUsage > givenQuota)
            // Save the modified record back to CloudKit
            do {
                try await self.database.save(record)
                // The record was saved successfully
                appData.setLoggedInIcloud(true)
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
        let record = CKRecord(recordType: UserUsageKeys.recordType.rawValue, recordID: CKRecord.ID(recordName: getRecordName(userId: user.wrappedId)))
        record.setValue(NSNumber(value: user.wrappedTotalUsage), forKey: UserUsageKeys.totalUsage.rawValue)
        record.setValue(500, forKey: UserUsageKeys.givenQuota.rawValue)
        record.setValue(Date(), forKey: UserUsageKeys.givenDate.rawValue)
        do {
            try await database.save(record)
            // The record was saved successfully
            appData.setLoggedInIcloud(true)
            print("UserUsage >> Successfully created!")
        } catch let saveError {
            // Handle the save error
            if saveError.localizedDescription.contains("CREATE operation not permitted") {
                appData.setLoggedInIcloud(false)
            }
            print("UserUsage >> Error creation: \(saveError.localizedDescription)")
        }
    }
    
    func checkIcloudLogin(completion: @escaping (Bool) -> Void) {
        container.accountStatus { (accountStatus, error) in
            switch accountStatus {
            case .couldNotDetermine, .restricted, .noAccount, .temporarilyUnavailable:
                print("Check Icloud >> Could not determine")
                completion(false)
            case .available:
                completion(true)
            @unknown default:
                print("Check Icloud >> Error future")
            }
        }
    }
    
    func quota(user: User, lastGivenDate: Date) -> Int {
        guard lastGivenDate.isPast() else {
            return 0
        }
        let dailyQuota = 500
        let maxDailyUsage = 1000
        let days = user.wrappedJoinDate.countDays(to: Date())
        let totalQuota = dailyQuota * (days + 1) // 5000
        let quota = totalQuota - Int(user.wrappedTotalUsage) // 4500
        let quotaGiven = quota > maxDailyUsage ? maxDailyUsage : quota
        
        return quotaGiven
    }
    
    func fetchAssets() async {
        let recordID = CKRecord.ID(recordName: "assetVersion")
        do {
            let record = try await database.record(for: recordID)
            let modificationDate = record.modificationDate
            
            if let modifiedDate = modificationDate, self.appData.shared.titleModifiedDate != modifiedDate.description {
                print("Assets >> Success!")
                await self.fetchLinks(modifiedDate)
            }
        } catch let error {
            print("SwiftKey >> Error fetch assets: \(error.localizedDescription)")
        }
    }
    
    func fetchLinks(_ date: Date) async {
        let recordID = CKRecord.ID(recordName: "links")
        do {
            let record = try await database.record(for: recordID)
            let linkSupport = record["linkSupport"] as? String ?? ""
            let linkAboutUs = record["linkAboutUs"] as? String ?? ""
            let linkPrivacyPolicy = record["linkPrivacyPolicy"] as? String ?? ""
            let linkTermsConditions = record["linkTermsConditions"] as? String ?? ""
            
            UserDefaults.standard.set(linkAboutUs, forKey: AppStorageKey.linkAboutUs.rawValue)
            UserDefaults.standard.set(linkPrivacyPolicy, forKey: AppStorageKey.linkPrivacyPolicy.rawValue)
            UserDefaults.standard.set(linkTermsConditions, forKey: AppStorageKey.linkTermsAndConditions.rawValue)
            
            CowriterLinks.saveLink(url: linkSupport) {result in
                print("Assets >> Success is \(result)!")
                self.appData.setTitleModifiedDate(date)
            }
            
        } catch let error {
            print("SwiftKey >> Error fetch swift: \(error.localizedDescription)")
        }
    }
    
    func sendSupportMessage(_ support: CustSupport) async {
        let record = CKRecord(recordType: "CustSupportType")
        record.setValue(support.user.wrappedName, forKey: "userName")
        record.setValue(support.user.wrappedId, forKey: "userId")
        record.setValue(support.content, forKey: "content")
        record.setValue(support.email, forKey: "email")
        record.setValue(support.subject, forKey: "subject")
        
        do {
            try await database.save(record)
            // The record was saved successfully
            print("SupportMessage >> Successfully sent!")
        } catch let saveError {
            // Handle the save error
            print("SupportMessage >> Error creation: \(saveError.localizedDescription)")
        }
    }
    
}

struct CustSupport {
    var subject, email, content: String
    var user: User
}
