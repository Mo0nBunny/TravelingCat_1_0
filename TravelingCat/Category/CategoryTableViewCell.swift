//
//  CategoryTableViewCell.swift
//  TravelingCat
//
//  Created by Sirin K on 07/12/2017.
//  Copyright © 2017 Sirin K. All rights reserved.
//

import UIKit
import UICircularProgressRing

class CategoryTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var categoryColor: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var inputCategory: UITextField!
    @IBOutlet weak var circularProgress: UICircularProgressRingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
