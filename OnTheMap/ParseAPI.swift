//
//  ParseAPI.swift
//  OnTheMap
//
//  Created by Robert Garza on 2/18/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import Foundation
import UIKit

private let sharedParse = ParseAPI()

class ParseAPI {
    
    var session = NSURLSession.sharedSession()
    let parseID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let parseKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    let parseURLString = "https://api.parse.com/1/classes/StudentLocation"
    let parseAppIDField = "X-Parse-Application-Id"
    let parseKeyIDField = "X-Parse-REST-API-Key"
    let parseUpdateString = "/8ZExGR5uX8"
    
    private var contextController: UIViewController?
    
    var studentArray: [Student] = []
    
    func getStudentData(viewController: UIViewController) {
        
        contextController = viewController
        
        let request = NSMutableURLRequest(URL: NSURL(string: parseURLString)!)
        request.addValue(parseID, forHTTPHeaderField: parseAppIDField)
        request.addValue(parseKey, forHTTPHeaderField: parseKeyIDField)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("error")
                return
            }
            
            guard let studentData = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary else {
                return
            }
            
            self.parseStudentData(studentData!)

        }
        task.resume()
    }
    
    //MARK: POST/PUT
    private func postStudentData(studentInformation: Student, requestType: String, updateOldData: Bool, objectId: String?) {
        var parseURL:String = ""
        if updateOldData {
            parseURL = parseURLString + objectId!
        } else {
            parseURL = parseURLString
        }
        let url = NSURL(string: parseURL)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = requestType
        request.addValue(parseID, forHTTPHeaderField: parseAppIDField)
        request.addValue(parseKey, forHTTPHeaderField: parseKeyIDField)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(studentInformation.uniqueKey)\", \"firstName\": \"\(studentInformation.firstName)\", \"lastName\": \"\(studentInformation.lastName)\",\"mapString\": \"\(studentInformation.mapString)\", \"mediaURL\": \"\(studentInformation.mediaURL)\",\"latitude\": \(studentInformation.latitude), \"longitude\": \(studentInformation.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                //handle error
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            guard let responseData = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary else {
                return
            }
            
            guard let containsError = responseData!["error"] else {
                
                let success = UIAlertAction(title: "Back to On The Map", style: .Default) {(action) in
                    self.contextController?.dismissViewControllerAnimated(true, completion: nil)
                }
                
                self.showAlert("Your location has been added.", header: "Success!", addButton: success, addCancelButton: false)
                return
            }
            
            self.showAlert(containsError as! String, header: "No URL input", addButton: nil, addCancelButton: true)
        }
        task.resume()
    }
    
    func queryParse(studentKey: String, completion: (httpMethod: String, objId: String?) ->Void) {
        let urlString = "https://api.parse.com/1/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(studentKey)%22%7D"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.addValue(parseID, forHTTPHeaderField: parseAppIDField)
        request.addValue(parseKey, forHTTPHeaderField: parseKeyIDField)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { /* Handle error */
                return
            }
            
            guard let queryData = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary else {
                return
            }
            
            guard let queryObjectId = queryData!["results"]![0]["objectId"] as? String else {
                return
            }
            
            var httpMethod = ""
            
            if queryObjectId != "" {
                httpMethod = "PUSH"
            } else {
                httpMethod = "PUT"
            }
            
            print(queryObjectId)
            completion(httpMethod: httpMethod, objId: queryObjectId)
        }
        task.resume()
    }
}


extension ParseAPI {
    
    
    //MARK: ParseJSON data
    
    private func parseStudentData(studentData: NSDictionary){
        
        studentArray = []
        
        guard let sortedData = studentData["results"] as? [[String: AnyObject]] else {
            print("no results")
            return
        }
        
        for result in sortedData {
            
            guard let uniqueKey = result["uniqueKey"] as? String else {
                print("Cannot find uniqueKey")
                return
            }
            
            guard let firstName = result["firstName"] as? String else {
                print("Cannot find firstName")
                return
            }
            
            guard let lastName = result["lastName"] as? String else {
                print("Cannot find lastName")
                return
            }
            
            guard let mediaURL = result["mediaURL"] as? String else {
                print("Cannot find mediaURL")
                return
            }
            
            guard let latitude = result["latitude"] as? Double else {
                print("Cannot find latitude")
                return
            }
            
            guard let longitude = result["longitude"] as? Double else {
                print("Cannot find longitude")
                return
            }
            
            guard let mapString = result["mapString"] as? String else {
                print("Cannot find mapString")
                return
            }
            
            let studentInformation = Student(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mediaURL: mediaURL, latitude: latitude, longitude: longitude, mapString: mapString)
            
            self.studentArray.append(studentInformation)
        }
        print(self.studentArray.count)
    }
    
    
    //MARK: Alert View
    
    private func showAlert(alertMessage: String, header: String, addButton: UIAlertAction?, addCancelButton: Bool) {
        
        let cancelPress = UIAlertAction(title: "Cancel", style: .Default) { (action) in
            return
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            let theAlert = UIAlertController(title: header, message: alertMessage, preferredStyle: .Alert)
            if addButton != nil {
                theAlert.addAction(addButton!)
            }
            if addCancelButton {
                theAlert.addAction(cancelPress)
            }
            self.contextController!.presentViewController(theAlert, animated: true, completion: nil)
        })
    }
    
    func setContextView(contextViewController: UIViewController) {
        contextController = contextViewController
    }
    
    //MARK: Shared Instance
    
    class func sharedInstance() -> ParseAPI {
        return sharedParse
    }
}