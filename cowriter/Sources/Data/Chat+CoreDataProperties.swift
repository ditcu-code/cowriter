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
    
    @NSManaged public var messages: NSSet?
    @NSManaged public var owner: User?
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedTitle: String {
        title ?? "SwiftChat"
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
    
    static func deleteChat(chat: Chat) {
        let context = PersistenceController.viewContext
        let messages = chat.messages?.allObjects as? [Message]
        
        // Delete all messages related to the chat
        if let messages = messages {
            for message in messages {
                Message.deleteMessage(message: message)
            }
        }
        
        // Delete the chat itself
        DispatchQueue.main.async {
            context.delete(chat)
            
            do {
                try context.save()
                // Deletion successful
            } catch {
                // Error handling for saving context
            }
        }
    }
    
}
