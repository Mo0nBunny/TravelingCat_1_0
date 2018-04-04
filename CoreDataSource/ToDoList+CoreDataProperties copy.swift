//
//  ToDoList+CoreDataProperties.swift
//  
//
//  Created by Sirin on 03/04/2018.
//
//

import Foundation
import CoreData


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var isDone: Bool
    @NSManaged public var task: String?
    @NSManaged public var category: Category?

}
