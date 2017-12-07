//
//  DetailViewController.swift
//  TravelingCat
//
//  Created by Sirin K on 07/12/2017.
//  Copyright © 2017 Sirin K. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var category: CaterogyData?
    var taskArray = [TaskData]()
    
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskArray.append(TaskData(task: ""))

        taskTableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        
        if let detailCategory = self.category {
            navigationItem.title = detailCategory.title
        }
       
        for taskItem: TaskData in ToDoTask.whatToDo {
            taskArray.append(taskItem)
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
//        self.taskArray.append(cell.inputTask.text!)
        cell.inputTask.text = taskArray[indexPath.row].task
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.taskArray.append(TaskData(task: textField.text!))
//        self.taskArray.append(TaskData(task:""))
        self.taskTableView.reloadData()
        print(self.taskArray)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.taskTableView.endEditing(true)
    }
}
