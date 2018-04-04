//
//  NewTripViewController.swift
//  TravelingCat
//
//  Created by Sirin on 29/03/2018.
//  Copyright © 2018 Sirin K. All rights reserved.
//

import UIKit
import CoreData

class NewTripViewController: UIViewController {

    @IBOutlet weak var tripTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
     let colorLabel = ["yellow", "blue", "green"]
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    @IBAction func addButtonTapped(_ sender: Any) {
        
        if tripTextField.text == "" || dateTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Enter trip and date", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Trip", in: context)
            let trip = Trip(entity: entity!, insertInto: context)
            // set all the properties
            trip.tripTitle = tripTextField.text
            trip.tripDate = dateTextField.text
            trip.tripImage = colorLabel[Int(arc4random_uniform(UInt32(colorLabel.count)))]
            appDelegate.coreDataStack.saveContext()
            print(trip)
        }
         performSegue(withIdentifier: "unwindSegueFromNewTrip", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
