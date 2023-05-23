//
//  Message+CoreDataProperties.swift
//  cowriter
//
//  Created by Aditya Cahyo on 21/04/23.
//
//

import Foundation
import CoreData


extension Message {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }
    
    @NSManaged public var content: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var role: String?
    
    @NSManaged public var chat: Chat?
    @NSManaged public var owner: User?
    
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedDate: Date {
        date ?? Date()
    }
    
    public var wrappedRole: String {
        role ?? "Unknown role"
    }
    
    
    public var wrappedContent: String {
        content ?? "Unknown content"
    }
    
}

extension Message : Identifiable {
    
    static func getFavoritesMessage() -> [Message]? {
        let context = PersistenceController.viewContext
        let request = Message.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == true")
        guard let items = try? context.fetch(request) else { return nil }
        return items
    }
    
    static func deleteMessage(message: Message) {
        let context = PersistenceController.viewContext
        context.delete(message)
        
        DispatchQueue.main.async {
            do {
                try context.save()
                // Deletion successful
            } catch {
                // Error handling for saving context
            }
        }
    }
    
}
