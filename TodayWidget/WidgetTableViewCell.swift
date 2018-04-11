//
//  WidgetTableViewCell.swift
//  TodayWidget
//
//  Created by Sirin on 10/04/2018.
//  Copyright © 2018 Sirin K. All rights reserved.
//

import UIKit

class WidgetTableViewCell: UITableViewCell {
    @IBOutlet weak var tripWidgetLabel: UILabel!
    @IBOutlet weak var dateWidgetLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
