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

class TripViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    var fetchResultsController: NSFetchedResultsController<Trip>!
    var tripArray: [Trip] = []
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var tripTableView: UITableView!
    
    @IBAction func close(segue: UIStoryboardSegue) {
    
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            AuthenticationManager.sharedInstance.loggedIn = false
            let presentingViewController = self.presentingViewController
            self.dismiss(animated: false, completion: {
                presentingViewController!.dismiss(animated: true, completion: {})
            })
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        }
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
        let sortDescriptor = NSSortDescriptor(key: "tripTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // getting context
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            // creating fetch result controller
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
             fetchResultsController.delegate = self
            // trying to retrieve data
            do {
                try fetchResultsController.performFetch()
                // save retrieved data into restaurants array
                tripArray = fetchResultsController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            self.context.delete(self.tripArray[indexPath.row])
            
            do {
                try self.context.save()
                self.tripArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
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
    }
}
