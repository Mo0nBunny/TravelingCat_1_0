//
//  ToDoList+CoreDataProperties.swift
//  TravelingCat
//
//  Created by Sirin K on 10/12/2017.
//  Copyright © 2017 Sirin K. All rights reserved.
//
//

import Foundation
import CoreData


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var task: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var category: Category?

}
