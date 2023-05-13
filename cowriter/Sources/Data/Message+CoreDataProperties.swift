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
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isPrompt: Bool
    @NSManaged public var role: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var chat: Chat?
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedContent: String {
        content ?? "Unknown content"
    }
    
    public var wrappedDate: Date {
        date ?? Date()
    }

}

extension Message : Identifiable {
    
    static func getFavoritesResult() -> [Message]? {
        let context = PersistenceController.viewContext
        let request = Message.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == true")
        guard let items = try? context.fetch(request) else { return nil }
        return items
    }

}
