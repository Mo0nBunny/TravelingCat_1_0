//
//  DefaultCategory.swift
//  TravelingCat
//
//  Created by Sirin K on 07/12/2017.
//  Copyright © 2017 Sirin K. All rights reserved.
//

import UIKit

struct DefaultCaterogy {
    static var whatToTake : [CaterogyData] = [
        CaterogyData(title: NSLocalizedString("014_default_cat_clothes", comment: ""), imageLabel: "yellow"),
        CaterogyData(title: NSLocalizedString("015_default_cat_medicine", comment: ""), imageLabel: "blue"),
        CaterogyData(title: NSLocalizedString("016_default_cat_documents", comment: ""), imageLabel: "green"),
        CaterogyData(title:NSLocalizedString("017_default_cat_devices", comment: ""), imageLabel: "violet")
    ]
}

