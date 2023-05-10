//
//  ChatType+CoreDataProperties.swift
//  cowriter
//
//  Created by Aditya Cahyo on 21/04/23.
//
//

import Foundation
import CoreData


extension ChatType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatType> {
        return NSFetchRequest<ChatType>(entityName: "ChatType")
    }

    @NSManaged public var title: String?
    @NSManaged public var userId: String?
    @NSManaged public var id: UUID?
    @NSManaged public var usage: Int32
    @NSManaged public var results: NSSet?
    
    public var wrappedTitle: String {
        title ?? "Cowriter"
    }
    
    public var wrappedUsage: Int {
        Int(usage)
    }
    
    public var wrappedUserId: String {
        userId ?? "Unknown UserId"
    }
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var resultsArray: [ResultType] {
        let set = results as? Set<ResultType> ?? []
        
        return set.sorted {
            $0.wrappedDate < $1.wrappedDate
        }
    }

}

// MARK: Generated accessors for results
extension ChatType {

    @objc(addResultsObject:)
    @NSManaged public func addToResults(_ value: ResultType)

    @objc(removeResultsObject:)
    @NSManaged public func removeFromResults(_ value: ResultType)

    @objc(addResults:)
    @NSManaged public func addToResults(_ values: NSSet)

    @objc(removeResults:)
    @NSManaged public func removeFromResults(_ values: NSSet)

}

extension ChatType : Identifiable {
    
    static func getAll() -> [ChatType] {
        let request = fetchRequest()
        do {
            let chats = try PersistenceController.viewContext.fetch(request)
            return chats
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    static func getById(with id: UUID?) -> ChatType? {
        let context = PersistenceController.viewContext
        guard let id = id else { return nil }
        let request = ChatType.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let items = try? context.fetch(request) else { return nil }
        return items.first
    }

}
