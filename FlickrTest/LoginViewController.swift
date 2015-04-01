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
                    self.webView.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
                    self.webView.delegate = self
                    //self.view.addSubview(self.webView)
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
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    
        var url: NSURL = request.URL
        
        println("the scheme is \(url.scheme!)")
        println("the url is: \(url)")
        
        //handle if we receive https://m.flickr.com/#/home because that means the user declined to authorize
        
        if (url.scheme! != "http"  && url.scheme! != "https") {
            //we received the callback
            println("callback received: \(url)")
            
            //finish authorization and store user info
            FlickrKit.sharedFlickrKit().completeAuthWithURL(url, completion: { (userName: String!, userId: String!, fullName: String!, error: NSError!) -> Void in
                if (error != nil) {
                    //something went wrong
                } else {
                    println("holy balls it actually worked! \( userName + userId + fullName)")
                }
            })
            
            
            self.dismissViewControllerAnimated(true, completion: nil)
            return false
        }
        
        return true
    }

}
