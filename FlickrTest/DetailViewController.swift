//
//  DetailViewController.swift
//  FlickrTest
//
//  Created by Tim Walsh on 4/1/15.
//  Copyright (c) 2015 ClassicTim. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var photo: NSDictionary?
    var imageView: UIImageView?
    var animator: UIDynamicAnimator?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 1.0, alpha: 0.95)
        
        self.imageView = UIImageView(frame: CGRectMake(0, -320, self.view.bounds.size.width, self.view.bounds.size.width))
        self.view.addSubview(self.imageView!)
        
        if let photoDictionary = self.photo { //just in case someone forgot to set the photo variable
            var url: NSURL = FlickrKit.sharedFlickrKit().photoURLForSize(FKPhotoSizeMedium640, fromPhotoDictionary: photoDictionary)
            PhotoController.imageForURL(url, size: "Medium640") { (image) -> Void in
                self.imageView!.image = image
            }
        }
        
//        self.imageView?.image.si
//        
//        self.imageView?.frame = CGRectMake(0, -320, <#width: CGFloat#>, <#height: CGFloat#>)
        
        
        var tap = UITapGestureRecognizer(target: self, action: "close")
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //set up the animation of the image
        self.animator = UIDynamicAnimator(referenceView: self.view)
        var snap = UISnapBehavior(item: self.imageView!, snapToPoint: self.view.center)
        self.animator?.addBehavior(snap)
    }
    
    
    func close() {
        
        self.animator?.removeAllBehaviors()
        
        var snap = UISnapBehavior(item: self.imageView!, snapToPoint: CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) + 180))
        self.animator?.addBehavior(snap)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
