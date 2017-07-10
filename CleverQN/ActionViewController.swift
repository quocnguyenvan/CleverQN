//
//  ActionViewController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/16/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class ActionViewController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5 // 2.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView
        let bounds = UIScreen.main.bounds
        
        //toViewController.view.frame = finalFrameForVC.offsetBy(dx: 0, dy: bounds.size.height)
        
        toViewController.view.frame = finalFrameForVC.offsetBy(dx: 0, dy: -bounds.size.height)
        
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            fromViewController.view.alpha = 0.5
            toViewController.view.frame = finalFrameForVC
        }, completion: { finished in
            transitionContext.completeTransition(true)
            fromViewController.view.alpha = 1.0
        })
    }
}
