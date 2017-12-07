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
    var taskArray = [String]()
    
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        
        if let detailCategory = self.category {
            navigationItem.title = detailCategory.title
        }
        for taskItem in taskArray {
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailTableViewCell
        cell.inputTask.delegate = self
        cell.inputTask.text = ""
        cell.inputTask.selectAll(nil)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        taskArray.append(textField.text!)
//        taskTableView.reloadData()
        print(taskArray)
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
