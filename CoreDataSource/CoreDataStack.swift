//
//  CoreDataStack.swift
//  TravelingCat
//
//  Created by Sirin on 20/03/2018.
//  Copyright © 2018 Sirin K. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
    
        let container = NSPersistentContainer(name: "TravelingCat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
