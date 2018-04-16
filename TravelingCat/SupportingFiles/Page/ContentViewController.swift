//
//  ContentViewController.swift
//  TravelingCat
//
//  Created by Sirin on 13/04/2018.
//  Copyright © 2018 Sirin K. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subheaderLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageButton: UIButton!
    
    @IBAction func pageButtonTapped(_ sender: Any) {
        switch index {
        case 0:
            let pageVC =  parent as! PageViewController
            pageVC.nextVC(atIndex: index)
        case 1:
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "introWatched")
            userDefaults.synchronize()
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    
    var header = ""
    var subheader = ""
    var imageFile = ""
    var index = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = header
        subheaderLabel.text = subheader
        imageView.image = UIImage(named: imageFile)
        pageControl.numberOfPages = 2
        pageControl.currentPage = index
        pageButton.layer.cornerRadius = 15
        pageButton.clipsToBounds = true
        pageButton.layer.borderWidth = 2
        pageButton.backgroundColor = #colorLiteral(red: 0.7065995932, green: 0.000459628267, blue: 0.1269010901, alpha: 1)
        pageButton.layer.borderColor = #colorLiteral(red: 0.6470588235, green: 0.137254902, blue: 0.1568627451, alpha: 1)
        
        switch index {
        case 0: pageButton.setTitle("Next", for: .normal)
        case 1: pageButton.setTitle("Got it", for: .normal)
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
