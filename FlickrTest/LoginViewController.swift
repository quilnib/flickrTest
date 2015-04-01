//
//  LoginViewController.swift
//  FlickrTest
//
//  Created by Tim Walsh on 3/31/15.
//  Copyright (c) 2015 ClassicTim. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.backgroundColor = UIColor.lightGrayColor()
        self.webView.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        self.webView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        self.logIntoFlickr()
    }
    
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
                    self.loadWebView(url!)
                })
            }
        })
    }
    
    func logOutOfFlickr() {
        var logoutURLString = "https://m.flickr.com/?iosauthlogout=1#iosauthlogout"
        var logoutURL: NSURL = NSURL(string: logoutURLString)!
        self.loadWebView(logoutURL)
    }
    
    //MARK: - webView operations
    
    func loadWebView(url:NSURL) {
        var request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        self.webView.loadRequest(request)
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        var urlFragments = webView.request?.URL.fragment
        var urlComponents: [String] = []
        if (urlFragments != nil) {
            urlComponents = split(urlFragments!, {$0=="/"}, maxSplit: 10, allowEmptySlices: false) as [String]
            
            for component in urlComponents  {
                if (component == "iosauthlogout") {
                    //if the user logged out then we want someone else to be able to login
                    self.logIntoFlickr()
                }
            }
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    
        var url: NSURL = request.URL
        
        if (url.scheme! != "http"  && url.scheme! != "https") {
            //we received the callback
            
            //finish authorization and store user info
            FlickrKit.sharedFlickrKit().completeAuthWithURL(url, completion: { (userName: String!, userId: String!, fullName: String!, error: NSError!) -> Void in
                if (error != nil) {
                    //something went wrong
                    println("\(error.userInfo)")
                } else {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
            
            return false
        } else {
            
            var urlFragments = url.fragment
            var urlComponents: [String] = []
            if (urlFragments != nil) {
                urlComponents = split(urlFragments!, {$0=="/"}, maxSplit: 10, allowEmptySlices: false) as [String]
                
                for component in urlComponents  {
                    //handle if we receive https://m.flickr.com/#/home because that means the user declined to authorize
                    if (component == "home") {
                        //the user declined authorization.
                        //display a notification to the user letting them know that the app can't work without them accepting the auth
                        //call logIntoFlickr()
                        let networkIssueController = UIAlertController(title: "Oops", message: "This application wont work without authorization", preferredStyle: .Alert)
                        
                        let okButton = UIAlertAction(title: "OK", style: .Default, handler: { (sender: UIAlertAction!) -> Void in
                            self.logIntoFlickr()
                        })
                        networkIssueController.addAction(okButton)
                        self.presentViewController(networkIssueController, animated: true, completion: nil)// you have to display the alert after you create it
                    }
                }
            }
            return true
        }
        
        //this should logically never be called
        return true
    }

}
