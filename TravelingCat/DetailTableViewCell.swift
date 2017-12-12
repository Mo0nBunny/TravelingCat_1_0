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
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        if checkButton.imageView?.image == #imageLiteral(resourceName: "check- empty"){
            checkButton.setImage(#imageLiteral(resourceName: "check- done"), for: .normal)
        } else {
            checkButton.setImage(#imageLiteral(resourceName: "check- empty"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
