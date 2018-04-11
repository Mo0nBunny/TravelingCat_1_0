//
//  Trip+CoreDataProperties.swift
//  
//
//  Created by Sirin on 03/04/2018.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var tripImage: String?
    @NSManaged public var tripTitle: String?
    @NSManaged public var tripDate: String?
    @NSManaged public var tripRemind: Date?
    @NSManaged public var categories: NSSet?

}

// MARK: Generated accessors for categories
extension Trip {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Category)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Category)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}
