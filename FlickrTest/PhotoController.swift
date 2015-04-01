//
//  PhotoController.swift
//  FlickrTest
//
//  Created by Tim Walsh on 3/31/15.
//  Copyright (c) 2015 ClassicTim. All rights reserved.
//

import UIKit

class PhotoController: NSObject {
   
    class func imageForURL(photoURL: NSURL, size: String, #completionHandler: ((image: UIImage) -> Void)) {
        
//        //generate a reuseable key for each photo to be used for cacheing
//        var key = (photo["id"] as String) + "-\(size)"
//        var image: UIImage? = SAMCache.sharedCache().imageForKey(key) //the : UIImage needs to be set to Optional so we can do a != nil check in the next step
//        
//        //if the photo is cached, then we do not need to request it again
//        if (image != nil) {
//            completionHandler(image: image!)
//            return
//        }
        
        //var photoUrlString = photo.valueForKeyPath("images.\(size).url") as String
        
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: photoURL)
        var task = session.downloadTaskWithRequest(request, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            
            println("the response: \(response)")
            var data = NSData(contentsOfURL: location) //going from data to image instead of NSURL to image avoids a lot of problems
            var image = UIImage(data: data!)
            //SAMCache.sharedCache().setImage(image, forKey: key)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(image: image!)
            })
        })
        task.resume()
        
    }
}

