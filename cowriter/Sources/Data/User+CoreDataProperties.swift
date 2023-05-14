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

    @NSManaged public var id: UUID?
    @NSManaged public var joinDate: Date?
    @NSManaged public var name: String?

    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedJoinDate: Date {
        joinDate ?? Date()
    }
    
    public var wrappedName: String {
        name ?? "Unknown name"
    }
    
}

extension User: Identifiable {
    
    public static func fetchFirstUser(in context: NSManagedObjectContext) -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            return results.first
            
        } catch {
            print("Error fetching first user: \(error.localizedDescription)")
            return nil
        }
    }
    
}


