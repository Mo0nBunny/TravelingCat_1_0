//
//  DetailViewController.swift
//  TravelingCat
//
//  Created by Sirin K on 07/12/2017.
//  Copyright © 2017 Sirin K. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    var category: Category?
    var taskArray = [ToDoList]()
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        print("button tapped")
        let cell: DetailTableViewCell = sender.superview?.superview as! DetailTableViewCell
        let table: UITableView = cell.superview as! UITableView
        let buttonIndexPath = table.indexPath(for: cell)
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let task = taskArray[(buttonIndexPath?.row)!]
        var taskIsDone: Bool
        
        if cell.checkButton.imageView?.image == #imageLiteral(resourceName: "check- empty") {
            taskIsDone = true
        } else {
            taskIsDone = false
        }
        task.isDone = taskIsDone
        task.category = category
//        appDelegate.saveContext()
        appDelegate.coreDataStack.saveContext()
        self.taskTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tasks = category?.tasks {
            self.taskArray = tasks.allObjects as! [ToDoList]
        }
        let taskArrayCount = taskArray.count
        if taskArrayCount == 0 {
            addNewTask()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "background2")
        let imageView = UIImageView(image: image)
        imageView.center = taskTableView.center
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.8
        taskTableView.backgroundView = imageView
        
        if let detailCategory = self.category {
            navigationItem.title = detailCategory.title
            print(detailCategory)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailTableViewCell
        cell.inputTask.delegate = self
        cell.inputTask.text = taskArray[indexPath.row].task
        
        let taskDone = taskArray[indexPath.row].isDone
        if taskDone == true {
            cell.checkButton.setImage(#imageLiteral(resourceName: "check- done"), for: .normal)
        } else {
            cell.checkButton.setImage(#imageLiteral(resourceName: "check- empty"), for: .normal)
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cell: DetailTableViewCell = textField.superview?.superview as! DetailTableViewCell
        let table: UITableView = cell.superview as! UITableView
        let textFieldIndexPath = table.indexPath(for: cell)
        
        cell.isEditing = false
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let task = taskArray[(textFieldIndexPath?.row)!]
        task.task = cell.inputTask.text!
        task.isDone = false
        task.category = category
//        appDelegate.saveContext()
        appDelegate.coreDataStack.saveContext()
        self.taskTableView.reloadData()
        
        addNewTask()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.taskTableView.endEditing(true)
    }
    
    func addNewTask() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let context = appDelegate.coreDataStack.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ToDoList", in: context)
        let task = ToDoList(entity: entity!, insertInto: context)
        task.task = ""
        task.isDone = false
        task.category = category
//        appDelegate.saveContext()
        appDelegate.coreDataStack.saveContext()
        taskArray.append(task)
        
        self.taskTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let managedContext = appDelegate.persistentContainer.viewContext
//            let managedContext = appDelegate.coreDataStack.persistentContainer.viewContext
//            managedContext.delete(self.taskArray[indexPath.row])
            context.delete(self.taskArray[indexPath.row])
            do {
//                try managedContext.save()
                try context.save()
                self.taskArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
}
