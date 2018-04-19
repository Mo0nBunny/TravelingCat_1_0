//
//  TripViewController.swift
//  TravelingCat
//
//  Created by Sirin on 27/03/2018.
//  Copyright © 2018 Sirin K. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import CloudKit

class TripViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate,  UIViewControllerTransitioningDelegate {
    
    var fetchResultsController: NSFetchedResultsController<Trip>!
    var tripArray: [Trip] = []
    var spinner: UIActivityIndicatorView!
    
   
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var syncButton: UIBarButtonItem!
    @IBOutlet weak var tripTableView: UITableView!
    
    @IBAction func close(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func syncButtonTapped(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: NSLocalizedString("001_app_name", comment: ""),
                                                message: NSLocalizedString("002_download_from_cloud", comment: ""),
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("003_yes", comment: ""), style: .default) { (action) in
            self.spinner.startAnimating()
            
            
            let privateDatabase = CKContainer.default().privateCloudDatabase
            let query = CKQuery(recordType: "Trip", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
            query.sortDescriptors = [NSSortDescriptor(key: "tripTitle", ascending: false)]
            privateDatabase.perform(query, inZoneWith: nil) { (results: [CKRecord]?, error: Error?) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
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
                            self.spinner.stopAnimating()
                        })
                    }
                }
            }
            self.tripTableView.reloadData()
        }
        
        
        let cancel = UIAlertAction(title: NSLocalizedString("004_no", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TripTableViewCell
        
        let trip = tripArray[indexPath.row]
        let tripName = trip.tripTitle
        let tripImage = trip.tripImage
        let tripDate = trip.tripDate
        let tripReminder = trip.tripRemind
        
        cell.tripLabel.text = tripName
        cell.dateLabel.text = tripDate
        
        if  let remindDate = tripReminder {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            cell.remindLabel.text = dateFormatter.string(from: remindDate)
        } else {
            cell.remindLabel.text = ""
        }
        cell.tripColor.image = UIImage(named: tripImage!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tripTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripTableView.reloadData()
        syncButton.setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: "AppleSDGothicNeo-Regular", size: 18)!], for: UIControlState.normal)
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.color = #colorLiteral(red: 0.7065995932, green: 0.000459628267, blue: 0.1269010901, alpha: 1)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        tripTableView.addSubview(spinner)
        
        NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: tripTableView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: tripTableView, attribute: .centerY, multiplier: 0.85, constant: 0).isActive = true
        
        self.tripTableView.delegate =  self
        self.tripTableView.dataSource = self
        //MARK: View without empty cells
        tripTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "tripDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            do {
                try fetchResultsController.performFetch()
                tripArray = fetchResultsController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = UserDefaults.standard
        let introWatched = userDefaults.bool(forKey: "introWatched")
        guard !introWatched else { return }
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "pageViewController") as? PageViewController {
            present(pageViewController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tripTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
        tripTableView.insertRows(at: [indexPath], with: .fade)
        case .delete: guard let indexPath = indexPath else { break }
        tripTableView.deleteRows(at: [indexPath], with: .fade)
        case .update: guard let indexPath = indexPath else { break }
        tripTableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tripTableView.reloadData()
        }
        tripArray = controller.fetchedObjects as! [Trip]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tripTableView.endUpdates()
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: NSLocalizedString("005_delete", comment: "")) {(action, indexPath) in
            self.deleteRecord(trip: self.tripArray[indexPath.row])
            self.context.delete(self.tripArray[indexPath.row])
            
            do {
                try self.context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
        //        let edit = UITableViewRowAction(style: .default, title: "Edit") {(action, indexPath) in
        //            self.isEditAction = true
        //            let cell = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell
        //            let oldName = cell.categoryLabel.text
        //            cell.inputCategory.text = oldName
        //            cell.inputCategory.selectAll(nil)
        //            cell.inputCategory.isHidden = false
        //            self.addBttn.isHidden = false
        //        }
        
        //        edit.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        delete.backgroundColor = #colorLiteral(red: 0.5803921569, green: 0.1764705882, blue: 0.1725490196, alpha: 1)
        
        return [delete]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCategory" {
            if let indexPath = self.tripTableView.indexPathForSelectedRow {
                let trip = tripArray[indexPath.row]
                let splitVC = segue.destination as! UISplitViewController
                let navVC = splitVC.childViewControllers.first as! UINavigationController
                let vc = navVC.childViewControllers.first as! MasterViewController
                vc.trip = trip
            }
            
        }
        
        if segue.identifier == "presentController" {
            let toViewController = segue.destination as UIViewController
            toViewController.transitioningDelegate = self
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentAnimator()
    }
    
    func deleteRecord(trip: Trip) {
        if let tripId = trip.id {
            CKContainer.default().privateCloudDatabase.fetch(withRecordID: CKRecordID(recordName: tripId)) { (record, error ) in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    } else {
                        if let tripRecord = record {
                            let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [tripRecord.recordID])
                            CKContainer.default().privateCloudDatabase.add(operation)
                            print("Trip deleted")
                        }
                    }
                }
            }
        }
    }

}
