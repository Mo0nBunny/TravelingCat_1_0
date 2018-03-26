//
//  Category+CoreDataProperties.swift
//  TravelingCat
//
//  Created by Sirin K on 10/12/2017.
//  Copyright © 2017 Sirin K. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var title: String?
    @NSManaged public var imageName: String?
    @NSManaged public var tasks: NSSet?

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
