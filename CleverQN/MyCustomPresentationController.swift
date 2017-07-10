//
//  MyCustomPresentationController.swift
//  SwiftCustomPresentation
//
//  Created by Quoc Nguyen on 6/19/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class MyAnimationController: NSObject, UIViewControllerAnimatedTransitioning{
    
    var isPresenting :Bool
    let duration :TimeInterval = 0.5
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentationTransition(transitionContext: transitionContext)
        } else {
            animateDismissalTransition(transitionContext: transitionContext)
        }
    }
    
    func animatePresentationTransition(transitionContext: UIViewControllerContextTransitioning){
        // Get everything you need
        let presentingViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let finalFrameForVC = transitionContext.finalFrame(for: presentingViewController)
        let containerView = transitionContext.containerView
        let bounds = UIScreen.main.bounds
        //move our presenting controller to the correct place, and add it to the view
        presentingViewController.view.frame = finalFrameForVC.offsetBy(dx: bounds.size.width, dy: 0)
        presentingViewController.view.alpha = 0.0
        containerView.addSubview(presentingViewController.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext), //set above
            delay: 0.0,
            options: .curveEaseOut, //Animation options
            animations: { //code for animation in closure
                presentingViewController.view.frame = finalFrameForVC
                presentingViewController.view.alpha = 1.0
        },
            completion: { finished in  //completion handler closure
                transitionContext.completeTransition(true)
        })
        
    }
    
    func animateDismissalTransition(transitionContext: UIViewControllerContextTransitioning){
        let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let containerView = transitionContext.containerView
        
        // Animate the presented view off the side
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0.0,
            options: .curveEaseIn,
            animations: {
                presentedControllerView!.frame.origin.x += containerView.frame.width
                presentedControllerView!.alpha = 0.0
        },
            completion: {(completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
        })
    }
}

class MyCustomPresentationController: UIPresentationController {
    let chrome = UIView()
//    let chromeColor = UIColor(red:0.0, green:0.0, blue:0.8, alpha: 0.4)
    let chromeColor = UIColor(white: 0.4, alpha: 0.6)
    
    
    override func presentationTransitionWillBegin() {
        
        chrome.frame = containerView!.bounds
        chrome.alpha = 0.0  //start with a invisible chrome
        //chrome.alpha = 1.0
        chrome.backgroundColor = chromeColor
        containerView!.insertSubview(chrome, at: 0)
        presentedViewController.transitionCoordinator!.animate(
            alongsideTransition: {context in
                self.chrome.alpha = 1.0
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator!.animate(
            alongsideTransition: { context in
                self.chrome.alpha = 0.0
        },
        completion: { context in
            self.chrome.removeFromSuperview()
        })
        //self.chrome.alpha = 0.0
        //self.chrome.removeFromSuperview()
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
//        return containerView!.bounds.insetBy(dx: 100, dy: 100)
        
        let newBounds = containerView!.bounds
        var newWidth:CGFloat = newBounds.width * 0.75
        
        if containerView!.traitCollection.horizontalSizeClass == .regular{
            newWidth = newBounds.width / 3.0 //1/3 view on regular width
        }
        
        let newXOrigin = newBounds.width - newWidth //set the origin from the right side
        return CGRect(x: newXOrigin, y: newBounds.origin.y, width: newWidth, height: newBounds.height)
    }
    
    override func containerViewWillLayoutSubviews() {
        chrome.frame = containerView!.bounds
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
}

class MyTransitioningDelegate : NSObject, UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(
        presented: UIViewController,
        presentingViewController presenting: UIViewController,
        sourceViewController source: UIViewController
        ) -> UIPresentationController? {
        
        return MyCustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        return MyAnimationController(isPresenting:true)
    }
    
    func animationControllerForDismissedController(
        dismissed: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        return MyAnimationController(isPresenting:false)
    }
}
