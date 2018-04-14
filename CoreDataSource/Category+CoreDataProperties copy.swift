//
//  Category+CoreDataProperties.swift
//  
//
//  Created by Sirin on 03/04/2018.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var imageName: String?
    @NSManaged public var title: String?
    @NSManaged public var tasks: NSSet?
    @NSManaged public var trip: Trip?
    @NSManaged public var creationDate: Date?

}

// MARK: Generated accessors for tasks
extension Category {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: ToDoList)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: ToDoList)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}
