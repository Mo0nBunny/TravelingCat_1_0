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
    
    var isEditAction: Bool = false
    var isAddAction: Bool = false
    let colorLabel = ["yellow", "blue", "green"]
    var categoryArray = [Category]()
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    @IBAction func addButton(_ sender: UIButton) {
        self.isAddAction = true
//        textFieldShouldBeginEditing()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let context = appDelegate.coreDataStack.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Category", in: context)
        
        let category = Category(entity: entity!, insertInto: context)
        category.title = "New Category"
        category.imageName = colorLabel[Int(arc4random_uniform(UInt32(colorLabel.count)))]
//        appDelegate.saveContext()
        appDelegate.coreDataStack.saveContext()
        categoryArray.append(category)
        self.categoryTableView.reloadData()
        
//        createNewCat()
//        categoryTableView.reloadData()
//        scrollToBottom()
//        let indexPath = lastIndexPath(categoryTableView)
//        print(indexPath)
//        categoryTableView.reloadData()
//        let cell = self.categoryTableView.visibleCells.last as! CategoryTableViewCell
//        print(indexPath)
//        let cell = self.categoryTableView.cellForRow(at: indexPath!) as! CategoryTableViewCell
//        let cell = self.categoryTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath!) as! CategoryTableViewCell
       
//        self.categoryTableView.beginUpdates()
//        let cell = self.categoryTableView.dequeueReusableCell(withIdentifier: "Cell", for: IndexPath.init(row: self.categoryArray.count-1, section: 0)) as! CategoryTableViewCell
//        cell.inputCategory.text = "New Category \(categoryArray.count)"
//        cell.inputCategory.selectAll(nil)
//        cell.inputCategory.isHidden = false
//        cell.inputCategory.delegate = self
//        self.categoryTableView.insertRows(at: [IndexPath.init(row: self.categoryArray.count-1, section: 0)], with: .automatic)
//        self.categoryTableView.endUpdates()
//        scrollToLastRow()
        
//        self.categoryTableView.beginUpdates()
//        let iPath = IndexPath(row: self.categoryArray.count - 1, section: 0)
//        self.categoryTableView.insertRows(at: [iPath], with: .bottom)
//        self.categoryTableView.endUpdates()
//        self.categoryTableView.reloadData()
//        self.categoryTableView.last
//        self.categoryTableView.reloadData()
//        let cell = self.categoryTableView.visibleCells.last as! CategoryTableViewCell
//        let cell = self.categoryTableView.cellForRow(at: IndexPath.init(row: self.categoryArray.count-1, section: 0)) as! CategoryTableViewCell

//        categoryTableView.reloadData()
//        self.categoryTableView.selectRow(at: IndexPath.init(row: self.categoryArray.count-1, section: 0), animated: true, scrollPosition: .bottom)
//        if let indexPath = self.categoryTableView.numberOfRows(inSection: 0) {
//        let cell = self.categoryTableView.cellForRow(at: IndexPath(row: self.categoryTableView.numberOfRows(inSection: 0), section: 0)) as! CategoryTableViewCell
//            let cell = self.categoryTableView.cellForRow(at: indexPath2) as! CategoryTableViewCell
//            let cell = self.categoryTableView.visibleCells.last as! CategoryTableViewCell
//        let cell = self.categoryTableView.dequeueReusableCell(withIdentifier: "Cell", for: IndexPath.init(row: self.categoryArray.count-1, section: 0)) as! CategoryTableViewCell
        
        if let lastIndexPath = lastIndexPath(self.categoryTableView) {
            var cell = self.categoryTableView.dataSource?.tableView(self.categoryTableView, cellForRowAt: lastIndexPath) as! CategoryTableViewCell
            cell = self.categoryTableView.visibleCells.last as! CategoryTableViewCell
            cell.inputCategory.text = "New Category \(categoryArray.count)"
            cell.inputCategory.selectAll(nil)
            cell.inputCategory.isHidden = false
//            cell.inputCategory.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let managedContext = appDelegate.coreDataStack.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        
        do {
//            let results = try managedContext.fetch(fetchRequest)
            let results = try context.fetch(fetchRequest)
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

        
        //from 3 methood
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)

       
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") {(action, indexPath) in
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let managedContext = appDelegate.persistentContainer.viewContext
//            let managedContext = appDelegate.coreDataStack.persistentContainer.viewContext
//            managedContext.delete(self.categoryArray[indexPath.row])
            self.context.delete(self.categoryArray[indexPath.row])
            do {
//                try managedContext.save()
                try self.context.save()
                self.categoryArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") {(action, indexPath) in
                        self.isEditAction = true
                        let cell = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell
                        let oldName = cell.categoryLabel.text
                        cell.inputCategory.text = oldName
                        cell.inputCategory.selectAll(nil)
                        cell.inputCategory.isHidden = false
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
            
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let category = categoryArray[categoryArray.count - 1]
            
            category.title = cell.inputCategory.text!
//            appDelegate.saveContext()
            appDelegate.coreDataStack.saveContext()
            self.categoryTableView.reloadData()
            
            //scroll to created row
            scrollToLastRow(self.categoryTableView)
            
            isAddAction = false
            
        } else if isEditAction == true {
            let cell: CategoryTableViewCell = textField.superview?.superview as! CategoryTableViewCell
            let table: UITableView = cell.superview as! UITableView
            let textFieldIndexPath = table.indexPath(for: cell)
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let category = categoryArray[(textFieldIndexPath?.row)!]
            category.title = cell.inputCategory.text!
//            appDelegate.saveContext()
            appDelegate.coreDataStack.saveContext()
            self.categoryTableView.reloadData()
            isEditAction = false
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if let indexPath = self.categoryTableView.indexPathForSelectedRow {
                let category = categoryArray[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.category = category
            }
        }
    }
    
    //MARK: Move textField
    
    // 3 methood
    
    @objc func keyboardWillShow(_ notification:Notification) {

        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            categoryTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height + 40, 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {

        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            categoryTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    func lastIndexPath(_ tableView: UITableView) -> IndexPath? {
        let sections = numberOfSections(in: tableView)
        for section in stride(from: sections, to: 0, by: -1) {
            let rows = self.tableView(tableView, numberOfRowsInSection: section)
            if rows > 0 {
                return IndexPath(row: rows - 1, section: sections - 1) //check section number here
            }
        }
        return nil
    }
    
    func scrollToLastRow(_ tableView: UITableView) {
        //TODO: Check logic here, to scroll only if cell outside view
        if let indexPath = lastIndexPath(tableView) {
//            if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
//                if !visibleIndexPaths.contains(indexPath) {
                    tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//                }
//            } else {
//                tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//            }
        }
    }
    
    func scrollToRow(_ tableView: UITableView, indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    
}
