//
//  TimePopupViewController.swift
//  TravelingCat
//
//  Created by Sirin on 08/04/2018.
//  Copyright © 2018 Sirin K. All rights reserved.
//

import UIKit

class TimePopupViewController: UIViewController {
    
    @IBOutlet weak var remindLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    
    var onSave: ((_ data: String) -> ())?
    
    var formattedTime: String {
        get {
            let formatter =  DateFormatter()
            formatter.dateFormat = "MM/dd/yy"
            
            return formatter.string(from: timePicker.date)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        onSave?(formattedTime)
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
}
