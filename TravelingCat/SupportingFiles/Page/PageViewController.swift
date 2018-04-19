//
//  PageViewController.swift
//  TravelingCat
//
//  Created by Sirin on 13/04/2018.
//  Copyright © 2018 Sirin K. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var headersArray = [NSLocalizedString("020_pageVC_from_dream_reality", comment: ""), NSLocalizedString("021_pageVC_be_org", comment: "")]
    var subheadersArray = [NSLocalizedString("022_pageVC_create_list_travelings", comment: ""), NSLocalizedString("023_pageVC_create_task", comment: "")]
    var imagesArray = ["Map", "Org"]

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let firstVC = displayViewController(atIndex: 0) {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayViewController(atIndex index: Int) -> ContentViewController? {
        guard index >= 0 else { return nil }
        guard index < headersArray.count else { return nil }
        guard let contentVC = storyboard?.instantiateViewController(withIdentifier:
            "contentViewController") as? ContentViewController else { return nil }
        
        contentVC.imageFile = imagesArray[index]
        contentVC.header = headersArray[index]
        contentVC.subheader = subheadersArray[index]
        contentVC.index = index
        
        return contentVC
    }
    
    func nextVC(atIndex index: Int) {
        if let contentVC = displayViewController(atIndex: index + 1) {
            setViewControllers([contentVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index -= 1
        return displayViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index += 1
        return displayViewController(atIndex: index)
    }
}
