//
//  DatePopupViewController.swift
//  TravelingCat
//
//  Created by Sirin on 08/04/2018.
//  Copyright © 2018 Sirin K. All rights reserved.
//

import UIKit

class DatePopupViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    
    var onSave: ((_ data: String) -> ())?
    
    var formattedDate: String {
        get {
            let formatter =  DateFormatter()
            formatter.dateStyle = .short
            return formatter.string(from: datePicker.date)
        }
    }
    
    @IBAction func saveDateTapped(_ sender: UIButton) {
       onSave?(formattedDate)
        dismiss(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
