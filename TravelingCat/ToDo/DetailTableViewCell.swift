//
//  DetailTableViewCell.swift
//  TravelingCat
//
//  Created by Sirin K on 07/12/2017.
//  Copyright © 2017 Sirin K. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var inputTask: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var doneLabel: UILabel!
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
