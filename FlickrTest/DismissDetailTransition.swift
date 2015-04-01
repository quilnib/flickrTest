//
//  DismissDetailTransition.swift
//  FlickrTest
//
//  Created by Tim Walsh on 4/1/15.
//  Copyright (c) 2015 ClassicTim. All rights reserved.
//

import UIKit

class DismissDetailTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        var detail: UIViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            detail.view.alpha = 0.0
            })
            { (finished: Bool) -> Void in
                detail.view.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.3
    }
    
}
