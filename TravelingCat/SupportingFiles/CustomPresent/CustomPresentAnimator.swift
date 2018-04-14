//
//  CustomPresentAnimator.swift
//  TravelingCat
//
//  Created by Sirin on 13/04/2018.
//  Copyright © 2018 Sirin K. All rights reserved.
//

import UIKit

class CustomPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }
        
        toViewController.view.alpha = 0
        transitionContext.containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toViewController.view.alpha = 1
        }, completion: {
            completed in
            transitionContext.completeTransition(true)
        })
    }
}
