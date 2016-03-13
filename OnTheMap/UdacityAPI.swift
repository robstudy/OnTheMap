//
//  UdacityAPI.swift
//  OnTheMap
//

import Foundation
import UIKit

//MARK: Singleton
private let sharedUdacity = UdacityAPI()

class UdacityAPI {
    
    private var session = NSURLSession.sharedSession()
    var studentInformation:(firstName: String, lastName: String, userKey: String)?
    var studentKey: String = ""
    
    //Call Session
    func startSession(eText emailText: String, pText passwordText: String, completion: (error: String?, completedRequest: Bool?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: UdacityStrings.url)!)
        request.HTTPMethod = UdacityStrings.httpPost
        request.addValue(UdacityStrings.valueJson, forHTTPHeaderField: UdacityStrings.accept)
        request.addValue(UdacityStrings.valueJson, forHTTPHeaderField: UdacityStrings.content)
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(emailText)\", \"password\": \"\(passwordText)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) in
            
            if error != nil { //Handle Error
                completion(error: Errors.connection, completedRequest: nil)
                return
            }
            
            guard let newData = data?.subdataWithRange(NSMakeRange(5, (data?.length)! - 5)) else {
                return
            }/*subset response data!*/
            
            guard let studentInfo = try? NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as? NSDictionary else {
                return
            }
            
            if studentInfo?["error"] != nil {
                completion(error: Errors.invalidCreditials, completedRequest: nil)
                return
            }
            
            guard let key = studentInfo?["account"]?["key"] as? String else {
                return
            }
            
            self.studentKey = key
            
            if let dataText = String(data: newData, encoding: NSUTF8StringEncoding) {
                if (dataText.rangeOfString("true") != nil) {
                    completion(error: nil, completedRequest: true)
                    return
                } else {
                    completion(error: Errors.invalidCreditials, completedRequest: nil)
                    return
                }
            }
        })
        task.resume()
    }
    
    //MARK: - Logout
    
    func logOut() {
        let request = NSMutableURLRequest(URL: NSURL(string: UdacityStrings.url)!)
        request.HTTPMethod = UdacityStrings.httpDelete
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as [NSHTTPCookie]! {
            if cookie.name == UdacityStrings.cookieName { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: UdacityStrings.cookieHeader)
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
        }
        task.resume()
    }
    
    //MARK: - Get Data
    
    func getUserData(){
        let request = NSMutableURLRequest(URL: NSURL(string: UdacityStrings.queryUrl + studentKey)!)
        let session = NSURLSession.sharedSession()

        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
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
    
    
    
    //MARK: - Shared Instance
    
    class func sharedInstance() -> UdacityAPI {
        return sharedUdacity
    }
}
