//
//  User+CoreDataProperties.swift
//  cowriter
//
//  Created by Aditya Cahyo on 14/05/23.
//
//

import Foundation
import CoreData


extension User {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
    
    @NSManaged public var id: String?
    @NSManaged public var joinDate: Date?
    @NSManaged public var name: String?
    
    @NSManaged public var chats: Chat?
    @NSManaged public var messages: Message?
    
    public var wrappedId: String {
        id ?? "Unknown id"
    }
    
    public var wrappedJoinDate: Date {
        joinDate ?? Date()
    }
    
    public var wrappedName: String {
        name ?? "Unknown name"
    }
    
}

// MARK: Generated accessors for chats
extension User {

    @objc(addChatsObject:)
    @NSManaged public func addToChats(_ value: Chat)

    @objc(removeChatsObject:)
    @NSManaged public func removeFromChats(_ value: Chat)

    @objc(addChats:)
    @NSManaged public func addToChats(_ values: NSSet)

    @objc(removeChats:)
    @NSManaged public func removeFromChats(_ values: NSSet)

}

extension User: Identifiable {
    
    public static func isZero(in context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.resultType = .countResultType
        
        do {
            let count = try context.count(for: fetchRequest)
            return count == 0
        } catch {
            print("Error fetching user count: \(error)")
            return true
        }
    }
    
    public static func fetchFirstUser(in context: NSManagedObjectContext) -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            print(results.first.debugDescription)
            return results.first
            
        } catch {
            print("Error fetching first user: \(error.localizedDescription)")
            return nil
        }
    }
    
}


