//
//  PhotosViewControllerCollectionViewController.swift
//  FlickrTest
//
//  Created by Tim Walsh on 3/31/15.
//  Copyright (c) 2015 ClassicTim. All rights reserved.
//

import UIKit

let reuseIdentifier = "PhotoCell"

class PhotosViewController: UICollectionViewController, UICollectionViewDelegate {

    var flickrUserName: String?
    var flickrUserId: String?
    var flickrFullName: String?
    var photos: [AnyObject] = []
    
    
//    required init(coder aDecoder: NSCoder) {
//        
//        super.init(coder: aDecoder)
//    }
//    
//    override init() {
//        var layout = UICollectionViewFlowLayout()
//        
//        super.init(collectionViewLayout: layout)
//        
//        //This has to be called AFTER super so we can get the view initialized
//        layout.itemSize = CGSizeMake( (view.bounds.width-2)/3, (view.frame.width-2)/3)
//        layout.minimumInteritemSpacing = 1.0
//        layout.minimumLineSpacing = 1.0
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set the layout and default cell size/spacing
        var layout = UICollectionViewFlowLayout()
        self.collectionView?.setCollectionViewLayout(layout, animated: true)
        layout.itemSize = CGSizeMake( (view.bounds.width-2)/3, (view.frame.width-2)/3)
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
        
        // Register cell classes
        self.collectionView!.registerClass(PhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.delegate = self
        self.title = "FlickrTest"
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        //FlickrKit.sharedFlickrKit().logout()
        FlickrKit.sharedFlickrKit().checkAuthorizationOnCompletion { (userName: String!, userId: String!, fullName: String!, error: NSError!) -> Void in
            if (error != nil) {
                //the user is not logged in and we should present the login process
                //call the LoginViewController and login
                self.performSegueWithIdentifier("showLogin", sender: self)
            } else {
                //the user's credentials are still present
                //request the photos
                self.flickrUserName = userName
                self.flickrUserId = userId
                self.flickrFullName = fullName
                self.refreshPhotos()
                println("still logged in")
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        //this isn't currently being called correctly because of the threading
        if (self.flickrUserId != nil) {
            //load the photos
            println("load the photos")
            self.refreshPhotos()
        } else {
            println("apparently we didn't want to load the photos")
        }
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showLogin") {
            //do any prep to the view controller that has to happen
            var loginController = segue.destinationViewController as LoginViewController
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.photos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PhotoCell
    
        // Configure the cell
        cell.backgroundColor = UIColor.lightGrayColor()
        cell.setPhoto(self.photos[indexPath.row] as NSDictionary)
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    func refreshPhotos() {
        FlickrKit.sharedFlickrKit().call("flickr.photos.search", args: ["userID": self.flickrUserId!, "per_page": "20"], maxCacheAge: FKDUMaxAgeOneHour) { (response: [NSObject : AnyObject]!, error: NSError!) -> Void in
            
            if (error != nil) {
                //something went wrong
                println("\(error.userInfo)")
            } else {
                println("the response: \(response)")
                var responseDictionary = response as NSDictionary
                self.photos = responseDictionary.valueForKeyPath("photos.photo") as [AnyObject]
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.collectionView!.reloadData()
                    
                })
            }
        }
    }
    
    
    @IBAction func logOutUser(sender: AnyObject) {
        FlickrKit.sharedFlickrKit().logout()
        //clean up any data that should be cleaned
        self.flickrUserName = nil
        self.flickrUserId = nil
        self.flickrFullName = nil
        self.photos.removeAll(keepCapacity: false)
        self.performSegueWithIdentifier("showLogin", sender: self)
    }

}
