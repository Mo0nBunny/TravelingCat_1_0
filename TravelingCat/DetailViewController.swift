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
    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
//    var category: CaterogyData?
    var category: Category?
//    var taskArray = [TaskData]()
     var taskArray = [ToDoList]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(category)
        
        if let tasks = category?.tasks {
            self.taskArray = tasks.allObjects as! [ToDoList]
        }
        
        let taskArrayCount = taskArray.count
        if taskArrayCount == 0 {
            addNewTask()
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let context = appDelegate.persistentContainer.viewContext
//            let entity = NSEntityDescription.entity(forEntityName: "ToDoList", in: context)
//
//            let task = ToDoList(entity: entity!, insertInto: context)
//            task.task = ""
//            task.isDone = false
//            task.category = category
//            appDelegate.saveContext()
//            taskArray.append(task)
//            self.taskTableView.reloadData()
        }
         print("Print after will appear \(taskArray)")
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoList")
//        
//        do {
//            let results = try managedContext.fetch(fetchRequest)
//            taskArray = results as! [ToDoList]
//        } catch let error as NSError {
//            print("Fetching Error: \(error.userInfo)")
//        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "background2")
        let imageView = UIImageView(image: image)
        imageView.center = taskTableView.center
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.8
        taskTableView.backgroundView = imageView
        
//        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        
//        imageView.alpha = 0.8
        
        if let detailCategory = self.category {
            navigationItem.title = detailCategory.title
            print(detailCategory)
        }
//
//        for taskItem: TaskData in ToDoTask.whatToDo {
//            taskArray.append(taskItem)
//        }
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
//        self.taskArray.append(cell.inputTask.text!)
        cell.inputTask.text = taskArray[indexPath.row].task
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        let cell = self.categoryTableView.visibleCells.last as! CategoryTableViewCell
//        cell.isEditing = false
//
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//        let category = categoryArray[categoryArray.count - 1]
//        category.title = cell.inputCategory.text!
//        category.imageName = "yellow"
//        appDelegate.saveContext()
//        self.categoryTableView.reloadData()
        let cell: DetailTableViewCell = textField.superview?.superview as! DetailTableViewCell
                    let table: UITableView = cell.superview as! UITableView
                    let textFieldIndexPath = table.indexPath(for: cell)
//        let cell = self.taskTableView.visibleCells.last as! DetailTableViewCell
        cell.isEditing = false
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let task = taskArray[(textFieldIndexPath?.row)!]
        task.task = cell.inputTask.text!
        task.isDone = false
        task.category = category
        appDelegate.saveContext()
        print("Print after save \(taskArray)")
        self.taskTableView.reloadData()
      
            addNewTask()
    
        print("Print after reload \(taskArray)")
//        self.taskArray.append(TaskData(task: textField.text!))
////        self.taskArray.append(TaskData(task:""))
//        self.taskTableView.reloadData()
//        print(self.taskArray)
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ToDoList", in: context)
        let task = ToDoList(entity: entity!, insertInto: context)
        task.task = ""
        task.isDone = false
        task.category = category
        appDelegate.saveContext()
        taskArray.append(task)
        
        self.taskTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(self.taskArray[indexPath.row])
            do {
                try managedContext.save()
                self.taskArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
}
