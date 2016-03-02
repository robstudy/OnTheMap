//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Robert Garza on 1/10/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import Foundation
import UIKit

//MARK: Singleton
private let sharedUdacity = UdacityAPI()

class UdacityAPI {
    
    var studentKey: String = ""
    
    private var session = NSURLSession.sharedSession()
    private var loginController: UIViewController?
    
    let udacityURLString = "https://www.udacity.com/api/session"
    
    //Call Session
    func startSession(eText emailText: String, pText passwordText: String, loginController: UIViewController) {
        let request = NSMutableURLRequest(URL: NSURL(string: udacityURLString)!)
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
            
            guard let studentInfo = try? NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as? NSDictionary else {
                print("no student information")
                return
            }
            
            guard let getStudentKey = studentInfo!["account"]!["key"] as? String else {
                print("No student key")
                return
            }
            
            self.studentKey = getStudentKey
            
            print(self.studentKey)
            
            
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            if let dataText = String(data: newData, encoding: NSUTF8StringEncoding) {
                if (dataText.rangeOfString("true") != nil) {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.loginController!.performSegueWithIdentifier("showTabC", sender: self)
                    })
                } else {
                    self.showAlert(self.loginController!, alertMessage: "Invalid user credentials")
                }
            }
        })
        task.resume()
    }
    
    //MARK: Logout
    
    func logOut() {
        let request = NSMutableURLRequest(URL: NSURL(string: udacityURLString)!)
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
    
    //MARK: Get Data
    func getUserData() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(studentKey)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                print(error)
                return
            }
            
            guard let newData = data?.subdataWithRange(NSMakeRange(5, data!.length - 5)) else {
                print("Can't get data")
                return
            }/* subset response data! */
            
            guard let studentArray = try? NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as? NSDictionary else {
                return
            }
            
            print(studentArray)
            
            //print(NSString(data: newData, encoding: NSUTF8StringEncoding))
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
