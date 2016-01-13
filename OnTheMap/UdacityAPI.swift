//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Robert Garza on 1/10/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import Foundation
import UIKit

class UdacityAPI : NSObject {
    
    var session: NSURLSession
    var errorString:String?
    var internetConnectionsError = false
    var udacityApiCallError = false
    
    override init(){
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    //Call Session
    func startSession(eText emailText: String, pText passwordText: String){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(emailText)\", \"password\": \"\(passwordText)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = session.dataTaskWithRequest(request){data, response, error in
            if error != nil { //Handle Error
                self.internetConnectionsError = true
                self.errorString = "Unable to connect to the internet!"
                return
            }
            guard let newData = data?.subdataWithRange(NSMakeRange(5, (data?.length)! - 5)) else {
                return
            }/*subset response data!*/
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        
            if let errorText = String(data: newData, encoding: NSUTF8StringEncoding) where errorText.rangeOfString("error") != nil {
                self.udacityApiCallError = true
                if errorText.rangeOfString("403") != nil {
                    self.errorString = "There was something wrong with your input Email/Password"
                    print(self.udacityApiCallError)
                    return
                } else {
                    self.errorString = errorText
                    return
                }
            }
        }
        task.resume()
    }
    
    //MARK: - Check For Errors
    
    func checkForInternetConnectionError() -> Bool {
        print(self.internetConnectionsError)
        return self.internetConnectionsError
    }
    
    func checkForApiCallError() -> Bool {
        print(self.udacityApiCallError)
        return self.udacityApiCallError
    }
    
    //MARK: - Set Errors
    func setErrorChecks(apiCallError udacityError: Bool, internetConnectionError: Bool) {
        self.udacityApiCallError = udacityError
        self.internetConnectionsError = internetConnectionError
    }
    
}
