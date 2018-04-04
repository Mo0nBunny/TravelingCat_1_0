//
//  TripDetailTableViewCell.swift
//  TravelingCat
//
//  Created by Sirin on 27/03/2018.
//  Copyright © 2018 Sirin K. All rights reserved.
//

import UIKit

class TripDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var detailColor: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
