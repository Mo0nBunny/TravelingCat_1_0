//
//  MasterViewController.swift
//  TravelingCat
//
//  Created by Sirin K on 07/12/2017.
//  Copyright © 2017 Sirin K. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var defaultData = [CaterogyData]()
    var isEditAction: Bool = false
    var isAddAction: Bool = false
    
    @IBOutlet weak var categoryTableView: UITableView!
    @IBAction func addButton(_ sender: UIButton) {
        self.isAddAction = true
        self.defaultData.append(CaterogyData(title: "New category", imageLabel: "yellow"))
        self.categoryTableView.reloadData()
        let cell = self.categoryTableView.visibleCells.last as! CategoryTableViewCell
        cell.inputCategory.text = "New Category \(defaultData.count)"
        cell.inputCategory.selectAll(nil)
        cell.inputCategory.isHidden = false
        cell.inputCategory.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.tableFooterView = UIView(frame: CGRect.zero)
        //Mark - without text on back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        for defaultItem: CaterogyData in DefaultCaterogy.whatToTake {
            defaultData.append(defaultItem)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoryTableViewCell
        cell.inputCategory.delegate = self
        cell.categoryColor.image = defaultData[indexPath.row].image
        cell.categoryLabel.text = defaultData[indexPath.row].title
        cell.inputCategory.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") {(action, indexPath) in
            self.defaultData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
            self.defaultData.removeLast()
            self.defaultData.append(CaterogyData(title: cell.inputCategory.text!, imageLabel: "yellow"))
            self.categoryTableView.reloadData()
            isAddAction = false
            
        } else if isEditAction == true {
            let cell: CategoryTableViewCell = textField.superview?.superview as! CategoryTableViewCell
            let table: UITableView = cell.superview as! UITableView
            let textFieldIndexPath = table.indexPath(for: cell)
            
            self.defaultData[(textFieldIndexPath?.row)!] = CaterogyData(title: cell.inputCategory.text!, imageLabel: "yellow")
            self.categoryTableView.reloadData()
            isEditAction = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if let indexPath = self.categoryTableView.indexPathForSelectedRow {
                let category = defaultData[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.category = category
            }
        }
    }
    
}
