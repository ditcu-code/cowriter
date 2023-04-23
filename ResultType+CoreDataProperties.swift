//
//  ResultType+CoreDataProperties.swift
//  cowriter
//
//  Created by Aditya Cahyo on 21/04/23.
//
//

import Foundation
import CoreData


extension ResultType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ResultType> {
        return NSFetchRequest<ResultType>(entityName: "ResultType")
    }

    @NSManaged public var answer: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var prompt: String?
    @NSManaged public var chat: ChatType?
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedAnswer: String {
        answer ?? "Unknown answer"
    }
    
    public var wrappedPrompt: String {
        prompt ?? "Unknown prompt"
    }
    
    public var wrappedDate: Date {
        date ?? Date()
    }

}

extension ResultType : Identifiable {

}
