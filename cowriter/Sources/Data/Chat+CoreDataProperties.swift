//
//  Chat+CoreDataProperties.swift
//  cowriter
//
//  Created by Aditya Cahyo on 21/04/23.
//
//

import Foundation
import CoreData


extension Chat {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var ownerId: String?
    @NSManaged public var tokenUsage: Int32
    
    @NSManaged public var messages: NSSet?
    
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedTitle: String {
        title ?? "Cowriter"
    }
    
    public var wrappedOwnerId: String {
        ownerId ?? "Unknown ownerId"
    }
    
    public var wrappedUsage: Int {
        Int(tokenUsage)
    }
    
    public var wrappedMessages: [Message] {
        let set = messages as? Set<Message> ?? []
        
        return set.sorted {
            $0.wrappedDate < $1.wrappedDate
        }
    }
    
}

// MARK: Generated accessors for messages
extension Chat {
    
    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)
    
    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)
    
    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)
    
    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)
    
}

extension Chat : Identifiable {
    
    static func getAll() -> [Chat] {
        let request = fetchRequest()
        do {
            let chats = try PersistenceController.viewContext.fetch(request)
            return chats
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
}