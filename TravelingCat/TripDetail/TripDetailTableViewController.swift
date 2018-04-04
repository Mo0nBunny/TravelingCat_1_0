//
//  TripDetailTableViewController.swift
//  TravelingCat
//
//  Created by Sirin on 26/03/2018.
//  Copyright © 2018 Sirin K. All rights reserved.
//

import UIKit

class TripDetailTableViewController: UITableViewController {
    
    var tripDetailArray = ["What to take?","Where to go?", "Memories"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        let lanternImage = UIImageView(frame: CGRect(origin: CGPoint(x: self.view.frame.width - 80 , y: 0.0),
                                       size:  CGSize(width: 68, height: 265)))
        print(lanternImage)
        lanternImage.image = UIImage(named: "lantern")
        lanternImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.addSubview(lanternImage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripDetailArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TripDetailTableViewCell
        cell.detailLabel.text = tripDetailArray[indexPath.row]
        cell.detailColor.image = UIImage(named: "green")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
}
