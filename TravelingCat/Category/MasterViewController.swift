//
//  MasterViewController.swift
//  TravelingCat
//
//  Created by Sirin K on 07/12/2017.
//  Copyright © 2017 Sirin K. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //    var defaultData = [CaterogyData]()
    var isEditAction: Bool = false
    var isAddAction: Bool = false
    
    var categoryArray = [Category]()
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    @IBAction func addButton(_ sender: UIButton) {
        self.isAddAction = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Category", in: context)
        
        let category = Category(entity: entity!, insertInto: context)
        category.title = "New Category"
        category.imageName = "yellow"
        appDelegate.saveContext()
        categoryArray.append(category)
        //        self.defaultData.append(CaterogyData(title: "New category", imageLabel: "yellow"))
        self.categoryTableView.reloadData()
        let cell = self.categoryTableView.visibleCells.last as! CategoryTableViewCell
        cell.inputCategory.text = "New Category \(categoryArray.count)"
        cell.inputCategory.selectAll(nil)
        cell.inputCategory.isHidden = false
        cell.inputCategory.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            categoryArray = results as! [Category]
        } catch let error as NSError {
            print("Fetching Error: \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.tableFooterView = UIView(frame: CGRect.zero)
        //Mark - without text on back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //        for defaultItem: CaterogyData in DefaultCaterogy.whatToTake {
        //            defaultData.append(defaultItem)
        //        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoryTableViewCell
        cell.inputCategory.delegate = self
        let category = categoryArray[indexPath.row]
        let categoryName = category.title
        let categoryImage = category.imageName
        cell.categoryLabel.text = categoryName
        
        cell.categoryColor.image = UIImage(named: categoryImage!)
        
        
        cell.inputCategory.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //            let managedContext = appDelegate.persistentContainer.viewContext
    //            managedContext.delete(self.categoryArray[indexPath.row])
    //        do {
    //            try managedContext.save()
    //            self.categoryArray.remove(at: indexPath.row)
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //            print("saved!")
    //        } catch let error as NSError  {
    //            print("Could not save \(error), \(error.userInfo)")
    //        }
    //        }
    //    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") {(action, indexPath) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(self.categoryArray[indexPath.row])
            do {
                try managedContext.save()
                self.categoryArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        let edit = UITableViewRowAction(style: .default, title: "Edit") {(action, indexPath) in
            //            self.isEditAction = true
            //            let cell = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell
            //            let oldName = cell.categoryLabel.text
            //            cell.inputCategory.text = oldName
            //            cell.inputCategory.selectAll(nil)
            //            cell.inputCategory.isHidden = false
        }
        
        edit.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        delete.backgroundColor = #colorLiteral(red: 0.5803921569, green: 0.1764705882, blue: 0.1725490196, alpha: 1)
        
        return [delete, edit]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.categoryTableView.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isAddAction == true {
            let cell = self.categoryTableView.visibleCells.last as! CategoryTableViewCell
            cell.isEditing = false
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let category = categoryArray[categoryArray.count - 1]
            category.title = cell.inputCategory.text!
            category.imageName = "yellow"
            appDelegate.saveContext()
            self.categoryTableView.reloadData()
            isAddAction = false
            
        } else if isEditAction == true {
            //            let cell: CategoryTableViewCell = textField.superview?.superview as! CategoryTableViewCell
            //            let table: UITableView = cell.superview as! UITableView
            //            let textFieldIndexPath = table.indexPath(for: cell)
            //
            //            self.defaultData[(textFieldIndexPath?.row)!] = CaterogyData(title: cell.inputCategory.text!, imageLabel: "yellow")
            //            self.categoryTableView.reloadData()
            isEditAction = false
        }
    }
    //Mark - old one
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "ShowDetail" {
    //            if let indexPath = self.categoryTableView.indexPathForSelectedRow {
    //                let category = defaultData[indexPath.row]
    //                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
    //                controller.category = category
    //            }
    //        }
    //    }
    
    
    // MArk new one
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "ShowTasksViewController" {
    //            let viewController = segue.destination as! TasksTableViewController
    //            let selectedIndexPath = tableView.indexPathForSelectedRow
    //            let person = people[(selectedIndexPath?.row)!]
    //            viewController.person = person
    //        }
    //    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if let indexPath = self.categoryTableView.indexPathForSelectedRow {
                let category = categoryArray[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.category = category
            }
        }
    }
    
    func deleteCategory(index : Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        
        //        let result = try? managedContext.fetch(fetchRequest)
        managedContext.delete(categoryArray[index])
        
        do {
            try managedContext.save()
            //updateDisplayOrder()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
}
