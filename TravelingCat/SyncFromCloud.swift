//
//  SyncFromCloud.swift
//  TravelingCat
//
//  Created by Sirin on 18/04/2018.
//  Copyright © 2018 Sirin K. All rights reserved.
//

import UIKit
import CloudKit
import CoreData

class SyncFromCloud {
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func syncFromCloud () {
        let privateDatabase = CKContainer.default().privateCloudDatabase
        let query = CKQuery(recordType: "Trip", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
        query.sortDescriptors = [NSSortDescriptor(key: "tripTitle", ascending: false)]
        privateDatabase.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: Error?) in
            if let trips = results {
                DispatchQueue.main.async(execute: {
                    for item: CKRecord in trips {
                        let entity = NSEntityDescription.entity(forEntityName: "Trip", in: self.context)
                        let trip = Trip(entity: entity!, insertInto: self.context)
                        trip.id = item.recordID.recordName
                        trip.tripDate = item["tripDate"] as? String
                        trip.tripImage = item["tripImage"] as? String
                        trip.tripTitle = item["tripTitle"] as? String
                        trip.tripRemind = item["tripRemind"] as? Date
                        
                        let categoryReference = CKReference(recordID: CKRecordID(recordName: (trip.id)!), action: .deleteSelf)
                        let categoryPredicate = NSPredicate(format: "trip == %@", categoryReference)
                        let categoryQuery = CKQuery(recordType: "Category", predicate: categoryPredicate)
                        privateDatabase.perform(categoryQuery, inZoneWith: nil, completionHandler: { (categoriesFromCloud, error) in
                            if let error = error {
                                print("Error: \(error.localizedDescription)")
                            } else {
                                if let categories = categoriesFromCloud {
                                    DispatchQueue.main.async {
                                        let categoryEntity = NSEntityDescription.entity(forEntityName: "Category", in: self.context)
                                        for item: CKRecord in categories {
                                            let category = Category(entity: categoryEntity!, insertInto: self.context)
                                            category.id = item.recordID.recordName
                                            category.title = item["title"] as? String
                                            category.imageName = item["imageName"] as? String
                                            category.trip = trip
                                            
                                            
                                            let toDoReference = CKReference(recordID: CKRecordID(recordName: (category.id)!), action: .deleteSelf)
                                            let toDoPredicate = NSPredicate(format: "category == %@", toDoReference)
                                            let toDoQuery = CKQuery(recordType: "ToDoList", predicate: toDoPredicate)
                                            privateDatabase.perform(toDoQuery, inZoneWith: nil, completionHandler: { (toDoFromCloud, error) in
                                                if let error = error {
                                                    print("Error: \(error.localizedDescription)")
                                                } else {
                                                    if let toDos = toDoFromCloud {
                                                        DispatchQueue.main.async {
                                                            let toDoEntity = NSEntityDescription.entity(forEntityName: "ToDoList", in: self.context)
                                                            for item: CKRecord in toDos {
                                                                let toDo = ToDoList(entity: toDoEntity!, insertInto: self.context)
                                                                toDo.id = item.recordID.recordName
                                                                toDo.task = item["task"] as? String
                                                                toDo.isDone = item["isDone"] as! Bool
                                                                toDo.category = category
                                                            }
                                                        }
                                                    }
                                                }
                                            })
                                        }
                                    }
                                }
                            }
                        })
                        self.appDelegate.coreDataStack.saveContext()
                    }
                })
            }
        }
    }
}
