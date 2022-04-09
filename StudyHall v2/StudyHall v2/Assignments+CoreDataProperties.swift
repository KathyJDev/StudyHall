//
//  Assignments+CoreDataProperties.swift
//  StudyHall v2
//
//  Created by Kathryn Jerez on 3/12/22.
//
//

import Foundation
import CoreData


extension Assignments {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Assignments> {
        return NSFetchRequest<Assignments>(entityName: "Assignments")
    }

    @NSManaged public var assignName: String?
    @NSManaged public var assignDate: Date?
    @NSManaged public var assignCompleted: Bool
    @NSManaged public var assignmentToDeveloper: Developer?
    @NSManaged public var assignid: UUID
    
    
    public var unwrappedName: String {
        assignName ?? "Unknown name"
    }
}

extension Assignments : Identifiable {

}
