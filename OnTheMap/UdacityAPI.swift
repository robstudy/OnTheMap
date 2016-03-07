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
    
    private var session = NSURLSession.sharedSession()
    private var viewController: UIViewController?
    private let udacityURLString = "https://www.udacity.com/api/session"
    var studentInformation:(firstName: String, lastName: String, userKey: String)?
    var studentKey: String = ""
    
    //Call Session
    func startSession(eText emailText: String, pText passwordText: String, completion: (error: String?, completedRequest: Bool?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: udacityURLString)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(emailText)\", \"password\": \"\(passwordText)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        print("\(request)")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) in
            
            if error != nil { //Handle Error
                completion(error: "Unable to connect to the internet", completedRequest: nil)
                return
            }
            
            guard let newData = data?.subdataWithRange(NSMakeRange(5, (data?.length)! - 5)) else {
                return
            }/*subset response data!*/
            
            guard let studentInfo = try? NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as? NSDictionary else {
                return
            }
            
            if studentInfo?["error"] != nil {
                completion(error: "Invalid user credentials", completedRequest: nil)
                return
            }
            
            guard let key = studentInfo?["account"]?["key"] as? String else {
                return
            }
            
            self.studentKey = key
            
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            if let dataText = String(data: newData, encoding: NSUTF8StringEncoding) {
                print(dataText)
                if (dataText.rangeOfString("true") != nil) {
                    completion(error: nil, completedRequest: true)
                    return
                } else {
                    completion(error: "Invalid user credentials", completedRequest: nil)
                    return
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
    func getUserData(){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(studentKey)")!)
        let session = NSURLSession.sharedSession()

        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                self.showAlert("\(error)")
                return
            }
            
            guard let newData = data?.subdataWithRange(NSMakeRange(5, data!.length - 5)) else {
                return
            }/* subset response data! */
            
            guard let studentArray = try? NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as? NSDictionary else {
                return
            }
            
            guard let key = studentArray!["user"]!["key"] as? String else {
                return
            }
            
            guard let firstName = studentArray!["user"]!["first_name"] as? String else {
                return
            }
            
            guard let lastName = studentArray!["user"]!["last_name"] as? String else {
                return
            }
            
            self.studentInformation = (firstName, lastName, key)
        }
        task.resume()
    }
    
    
    //MARK: Show Alert
    
    private func showAlert(alertMessage: String) {
        
        let okPress = UIAlertAction(title: "OK", style: .Default) {(action) in
            return
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            let noConnectionAlert = UIAlertController(title: "Oh No!", message: alertMessage, preferredStyle: .Alert)
            noConnectionAlert.addAction(okPress)
            self.viewController!.presentViewController(noConnectionAlert, animated: true, completion: nil)
        })
    }
    
    //MARK: Shared Instance
    
    class func sharedInstance() -> UdacityAPI {
        return sharedUdacity
    }
}
