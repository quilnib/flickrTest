//
//  PresentDetailTransition.swift
//  FlickrTest
//
//  Created by Tim Walsh on 4/1/15.
//  Copyright (c) 2015 ClassicTim. All rights reserved.
//

import UIKit

class PresentDetailTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        var detail: UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var containerView: UIView = transitionContext.containerView()
        
        detail.view.alpha = 0.0
        
        var frame = containerView.bounds
        frame.origin.y += 20//make sure we can see the toolbar
        frame.size.height -= 20 //so the container still fits the screen
        detail.view.frame = frame
        containerView.addSubview(detail.view) //be sure to add to the containerView, or nothing will happen!!
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            detail.view.alpha = 1
            })
            { (finished: Bool) -> Void in
                transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.3
    }
    
}

