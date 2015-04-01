//
//  PhotosViewControllerCollectionViewController.swift
//  FlickrTest
//
//  Created by Tim Walsh on 3/31/15.
//  Copyright (c) 2015 ClassicTim. All rights reserved.
//

import UIKit

let reuseIdentifier = "PhotoCell"

class PhotosViewController: UICollectionViewController, UIViewControllerTransitioningDelegate {

    var flickrUserName: String?
    var flickrUserId: String?
    var flickrFullName: String?
    var photos: [AnyObject] = []
    var pages: Int?
    
    
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
        self.title = "FlickrTest"
        self.collectionView?.backgroundColor = UIColor.whiteColor()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.checkLoggedIn()
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showLogin") {
            //do any prep to the view controller that has to happen
            var loginController = segue.destinationViewController as LoginViewController
            FlickrKit.sharedFlickrKit().logout()
            //clean up any data that should be cleaned
            self.flickrUserName = nil
            self.flickrUserId = nil
            self.flickrFullName = nil
            self.photos.removeAll(keepCapacity: false)
            self.collectionView!.reloadData()
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var photo = self.photos[indexPath.row] as NSDictionary
        var viewController = DetailViewController()
        //set the viewController to use a custom transition.  Be sure to implement the UIViewControllerTransitioningDelegate protocol
        viewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        viewController.transitioningDelegate = self //this is why we need to implement the UIViewControllerTransitioningDelegate protocol
        viewController.photo = photo
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    
    func refreshPhotos() {
        FlickrKit.sharedFlickrKit().call("flickr.photos.search", args: ["user_id": self.flickrUserId!, "per_page": "20"], maxCacheAge: FKDUMaxAgeNeverCache) { (response: [NSObject : AnyObject]!, error: NSError!) -> Void in
            
            if (error != nil) {
                //something went wrong
                println("\(error.userInfo)")
            } else {
                println("the response: \(response)")
                var responseDictionary = response as NSDictionary
                self.photos = responseDictionary.valueForKeyPath("photos.photo") as [AnyObject]
                self.pages = (responseDictionary.valueForKeyPath("photos.pages") as Int)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.collectionView!.reloadData()
                    self.retreiveRestOfPhotos()
                    
                })
            }
        }
    }
    
    func retreiveRestOfPhotos() {
        
        if (self.pages > 1) {
            for( var i = 2; i <= self.pages; i++) {
                FlickrKit.sharedFlickrKit().call("flickr.photos.search", args: ["user_id": self.flickrUserId!, "per_page": "20", "page": String(i)], maxCacheAge: FKDUMaxAgeNeverCache) { (response: [NSObject : AnyObject]!, error: NSError!) -> Void in
                    
                    if (error != nil) {
                        //something went wrong
                        println("error retreiving rest of photos: \(error.userInfo)")
                    } else {
                        println("the response: \(response)")
                        var responseDictionary = response as NSDictionary
                        var dictionaryPhotos = responseDictionary.valueForKeyPath("photos.photo") as [AnyObject]
                        var index = self.photos.count
                        var indexArray: [NSIndexPath] = []
                        for( var i = index; i < (self.photos.count + dictionaryPhotos.count); i++) {
                            indexArray.append(NSIndexPath(forRow: i, inSection: 0))
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.collectionView!.performBatchUpdates({ () -> Void in
                                
                                self.photos += dictionaryPhotos
                                self.collectionView?.insertItemsAtIndexPaths(indexArray)
                                
                                }, completion: nil)
                        })
                    }
                }
            }
        }
    }
    
    //MARK: - UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentDetailTransition()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissDetailTransition()
    }

    //MARK: - helper methods
    
    func checkLoggedIn() {
        FlickrKit.sharedFlickrKit().checkAuthorizationOnCompletion { (userName: String!, userId: String!, fullName: String!, error: NSError!) -> Void in
            if (error != nil) {
                //the user is not logged in and we should present the login process
                //call the LoginViewController and login
                println("\(error.userInfo)")
                self.performSegueWithIdentifier("showLogin", sender: self)
            } else {
                //the user's credentials are still present
                //request the photos
                self.flickrUserName = userName
                self.flickrUserId = userId
                self.flickrFullName = fullName
                self.refreshPhotos()
            }
        }
    }
    
    
    @IBAction func logOutUser(sender: AnyObject) {
        
        self.performSegueWithIdentifier("showLogin", sender: self)
    }
    

}
