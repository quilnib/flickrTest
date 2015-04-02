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
        
        //assuming all images are square, which isn't the case on flickr
        self.imageView = UIImageView(frame: CGRectMake(0, -320, self.view.bounds.size.width, self.view.bounds.size.width))
        self.view.addSubview(self.imageView!)
        
        if let photoDictionary = self.photo { //just in case someone forgot to set the photo variable
            FlickrKit.sharedFlickrKit().call("flickr.photos.getSizes", args: ["photo_id": photoDictionary.valueForKey("id")!], completion: { (response: [NSObject : AnyObject]!, error: NSError!) -> Void in
                if (error != nil) {
                    //something went wrong
                    println("\(error.userInfo)")
                } else {
                    println("\(response)")
                    
                    var dictionary = response as NSDictionary
                    var sizes: [AnyObject] = dictionary.valueForKeyPath("sizes.size") as [AnyObject]
                    var height: Int?
                    var width: Int?
                    for( var i = 0; i < sizes.count; i++) {
                        var temp = sizes[i] as NSDictionary
                        if ((temp.valueForKey("label") as String) == "Medium 640") {
                            if let tempHeight = (temp.valueForKey("height") as? String) {
                                height = tempHeight.toInt()
                            }
                            if let tempWidth = (temp.valueForKey("width") as? String) {
                                width = tempWidth.toInt()
                            }
                        
                            i = sizes.count
                        }
                    }
                    if (height != nil && width != nil) {
                        if (height > width) {
                            var x: CGFloat = CGFloat(width!) / CGFloat(2.0)
                            var screenWidth: CGFloat = self.view.bounds.width
                            var fromX = screenWidth - x
                            var fromXDivTwo = fromX / 2
                            self.imageView!.frame = CGRectMake( fromXDivTwo, -320, CGFloat(width!/2), CGFloat(height!/2))
                        } else if (width > height) {
                            var x: CGFloat = CGFloat(width!) / CGFloat(2.0)
                            var screenHeight: CGFloat = self.view.bounds.height
                            var fromX = screenHeight - x
                            var fromXDivTwo = fromX / 2
                            self.imageView!.frame = CGRectMake( fromXDivTwo, -320, CGFloat(width!/2), CGFloat(height!/2))
                        } else {
                           //no need to change it.  It's already a square
                        }
                    }
                    
                    var url: NSURL = FlickrKit.sharedFlickrKit().photoURLForSize(FKPhotoSizeMedium640, fromPhotoDictionary: photoDictionary)
                    PhotoController.imageForURL(url, size: "Medium640") { (image) -> Void in
                        self.imageView!.image = image
                    }
                }
            })
            
        }
        
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
