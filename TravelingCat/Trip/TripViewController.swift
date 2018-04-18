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
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var tripTableView: UITableView!
    
    @IBAction func close(segue: UIStoryboardSegue) {
    
    }
    
    @IBAction func syncButtonTapped(_ sender: UIBarButtonItem) {
        
        
        
        
        
        
        
        
        
        
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
    
        let delete = UITableViewRowAction(style: .default, title: "Delete") {(action, indexPath) in
            self.deleteRecord(trip: self.tripArray[indexPath.row])
            self.context.delete(self.tripArray[indexPath.row])

            do {
                try self.context.save()
//                self.tripArray.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .fade)
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
