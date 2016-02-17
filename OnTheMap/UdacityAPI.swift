//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Robert Garza on 1/10/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import Foundation
import UIKit

private let sharedUdacity = UdacityAPI()

class UdacityAPI : NSObject {
    
    var session = NSURLSession.sharedSession()
    var loginController: UIViewController?
    
    override init(){
        super.init()
    }
    
    //Call Session
    func startSession(eText emailText: String, pText passwordText: String, loginController: UIViewController) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(emailText)\", \"password\": \"\(passwordText)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        self.loginController = loginController
        
        udacityPOSTRequest(request)
    }
    
    //MARK: Post Request
    
    private func udacityPOSTRequest(request: NSURLRequest!){
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) in
            
            if error != nil { //Handle Error
                self.showAlert(self.loginController!, alertMessage: "Unable to connect to the internet!")
                return
            }
            
            guard let newData = data?.subdataWithRange(NSMakeRange(5, (data?.length)! - 5)) else {
                return
            }/*subset response data!*/
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            if let dataText = String(data: newData, encoding: NSUTF8StringEncoding) {
                if dataText.rangeOfString("403") != nil {
                    self.showAlert(self.loginController!, alertMessage: "error: There was something wrong with your input Email/Password" )
                    return
                } else if (dataText.rangeOfString("true") != nil) {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.loginController!.performSegueWithIdentifier("showTabC", sender: self)
                    })
                } else {
                    self.showAlert(self.loginController!, alertMessage: dataText)
                }
            }
        })
        task.resume()
    }
    
    //Logout
    
    func logOut() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as [NSHTTPCookie]! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
    
    //MARK: Show Alert
    
    func showAlert(viewController: UIViewController, alertMessage: String) {
        
        let okPress = UIAlertAction(title: "OK", style: .Default) {(action) in
            viewController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            let noConnectionAlert = UIAlertController(title: "Oh No!", message: alertMessage, preferredStyle: .Alert)
            noConnectionAlert.addAction(okPress)
            viewController.presentViewController(noConnectionAlert, animated: true, completion: nil)
        })
    }

    
    //MARK: Shared Instance
    
    class func sharedInstance() -> UdacityAPI {
        return sharedUdacity
    }
}
