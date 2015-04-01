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
        

        //we could implement caching in here to speed things up
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: photoURL)
        var task = session.downloadTaskWithRequest(request, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            
            var data = NSData(contentsOfURL: location) //going from data to image instead of NSURL to image avoids a lot of problems
            var image = UIImage(data: data!)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(image: image!)
            })
        })
        task.resume()
        
    }
}

