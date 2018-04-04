//
//  MainViewController.swift
//  TravelingCat
//
//  Created by Sirin on 27/03/2018.
//  Copyright © 2018 Sirin K. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var logIn: UIButton!
    @IBOutlet weak var singUp: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logIn.layer.cornerRadius = 18
        logIn.layer.borderWidth = 1.2
        logIn.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        logIn.clipsToBounds = true
        
        singUp.layer.cornerRadius = 18
        singUp.layer.borderWidth = 1.2
        singUp.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        singUp.clipsToBounds = true
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
