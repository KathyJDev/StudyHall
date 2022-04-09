//
//  Developer+CoreDataProperties.swift
//  StudyHall v2
//
//  Created by Kathryn Jerez on 3/20/22.
//
//

import Foundation
import CoreData


extension Developer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Developer> {
        return NSFetchRequest<Developer>(entityName: "Developer")
    }

    @NSManaged public var descriptions: String?
    @NSManaged public var imageD: Data?
    @NSManaged public var userid: UUID?
    @NSManaged public var username: String?
    @NSManaged public var icon: String?
    @NSManaged public var developerToAssignment: NSSet?
    
    public var unwrappedName: String {
            username ?? "Unknown name"
        }
    
    public var assignmentArray: [Assignments] {
            let assignmentset = developerToAssignment as? Set<Assignments> ?? []
            
            return assignmentset.sorted {
                $0.unwrappedName < $1.unwrappedName
            }
        }

}

// MARK: Generated accessors for developerToAssignment
extension Developer {

    @objc(addDeveloperToAssignmentObject:)
    @NSManaged public func addToDeveloperToAssignment(_ value: Assignments)

    @objc(removeDeveloperToAssignmentObject:)
    @NSManaged public func removeFromDeveloperToAssignment(_ value: Assignments)

    @objc(addDeveloperToAssignment:)
    @NSManaged public func addToDeveloperToAssignment(_ values: NSSet)

    @objc(removeDeveloperToAssignment:)
    @NSManaged public func removeFromDeveloperToAssignment(_ values: NSSet)

}

extension Developer : Identifiable {

}
