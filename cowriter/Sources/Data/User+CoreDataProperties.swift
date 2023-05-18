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
    @NSManaged public var totalUsage: Int32
    
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

// MARK: Generated accessors for messages
extension User {
    
    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)
    
    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)
    
    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)
    
    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)
    
}

extension User: Identifiable {
    
    public static func isEmpty(completion: @escaping (Bool) -> Void) {
        let context = PersistenceController.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.resultType = .countResultType
        
        do {
            let count = try context.count(for: fetchRequest)
            completion(count == 0)
        } catch {
            print("Error fetching user count: \(error)")
            completion(true)
        }
    }
    
    public static func fetchFirstUser() -> User? {
        let context = PersistenceController.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "joinDate", ascending: true)]
        request.fetchLimit = 1
        
        do {
            let users = try context.fetch(request)
            return users.first
        } catch {
            print("Error fetching first user: \(error)")
            return nil
        }
    }
    
    public static func fetchAll() -> [User]? {
        let context = PersistenceController.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            print(results.first.debugDescription)
            return results
            
        } catch {
            print("Error fetching first user: \(error.localizedDescription)")
            return []
        }
    }
    
}


