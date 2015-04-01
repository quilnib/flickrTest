//
//  PhotosViewControllerCollectionViewController.swift
//  FlickrTest
//
//  Created by Tim Walsh on 3/31/15.
//  Copyright (c) 2015 ClassicTim. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class PhotosViewController: UICollectionViewController {

    @IBOutlet var webView: UIWebView!
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override init() {
        var layout = UICollectionViewFlowLayout()
        
        super.init(collectionViewLayout: layout)
        
        //This has to be called AFTER super so we can get the view initialized
        layout.itemSize = CGSizeMake( (view.frame.width-2)/3, (view.frame.width-2)/3)
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        self.title = "FlickrTest"
        
        //FlickrKit.sharedFlickrKit().logout()
        FlickrKit.sharedFlickrKit().checkAuthorizationOnCompletion { (userName: String!, userId: String!, fullName: String!, error: NSError!) -> Void in
            if (error != nil) {
                //the user is not logged in and we should present the login process
                self.logIntoFlickr()
            } else {
                //the user's credentials are still present
                println("still logged in")
            }
        }
        
        FlickrKit.sharedFlickrKit()
        
          // Do any additional setup after loading the view.
        
//        // 1. Begin Authorization, onSuccess display authURL in a UIWebView - the url is a callback into your app with a URL scheme
//        - (FKDUNetworkOperation *) beginAuthWithCallbackURL:(NSURL *)url permission:(FKPermission)permission completion:(FKAPIAuthBeginCompletion)completion;
//        // 2. After they login and authorize the app, need to get an auth token - this will happen via your URL scheme - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//        - (FKDUNetworkOperation *) completeAuthWithURL:(NSURL *)url completion:(FKAPIAuthCompletion)completion;
//        // 3. On returning to the app, you want to re-log them in automatically - do it here
//        - (FKFlickrNetworkOperation *) checkAuthorizationOnCompletion:(FKAPIAuthCompletion)completion;
//        // 4. Logout - just removes all the stored keys
//        - (void) logout;
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 10
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
    
        // Configure the cell
        cell.backgroundColor = UIColor.lightGrayColor()
    
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
    
    //MARK: - Flickr methods
    
    func logIntoFlickr() {
        let callbackURL: NSURL = NSURL(string: "flickrtest://auth")!
        FlickrKit.sharedFlickrKit().beginAuthWithCallbackURL(callbackURL, permission: FKPermissionRead, completion: { (url: NSURL!, error: NSError!) -> Void in
            //code
            if (error != nil) {
                //something went wrong
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    println("authorization url \(url!)")
                    self.webView.frame = CGRectMake(0, 64, self.view.bounds.width, self.view.bounds.height - 64)
                    self.view.addSubview(self.webView)
                    self.loadWebView(url!)
                })
                
            }
        })

    }
    
    //MARK: - webView operations
    
    func loadWebView(url:NSURL) {
        var request = NSURLRequest(URL: url)
        self.webView.loadRequest(request)
        
    }

}
