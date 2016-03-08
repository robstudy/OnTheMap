//
//  ParseAPI.swift
//  OnTheMap
//
//  Created by Robert Garza on 2/18/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import Foundation

private let sharedParse = ParseAPI()

class ParseAPI {
    
    private var session = NSURLSession.sharedSession()
    private let parseID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    private let parseKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    private let parseURLString = "https://api.parse.com/1/classes/StudentLocation"
    private let parseAppIDField = "X-Parse-Application-Id"
    private let parseKeyIDField = "X-Parse-REST-API-Key"
    private let parseUpdateString = "/8ZExGR5uX8"
    
    func getStudentData(completion: (success:Bool)->Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: parseURLString)!)
        request.addValue(parseID, forHTTPHeaderField: parseAppIDField)
        request.addValue(parseKey, forHTTPHeaderField: parseKeyIDField)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                return
            }
            
            guard let studentData = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary else {
                return
            }
            
            self.parseStudentData(studentData!, comletion: {(success) in
                if success == true {
                    completion(success: true)
                    return
                } else {
                    completion(success: false)
                    return
                }
            })
        }
        task.resume()
    }
    
    //MARK: POST/PUT
    func postStudentData(studentInformation: Student, requestType: String, updateOldData: Bool, objectId: String?, completion: (error: String?, success: Bool)->Void) {
        var parseURL:String = ""
        if updateOldData {
            parseURL = parseURLString + "/" + objectId!
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
            
            guard let responseData = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary else {
                return
            }
            
            if let containsError = responseData!["error"] as? String {
                completion(error: containsError, success: false)
                return
            }
            
            completion(error: nil, success: true)
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
                httpMethod = "PUT"
            } else {
                httpMethod = "PUSH"
            }

            completion(httpMethod: httpMethod, objId: queryObjectId)
        }
        task.resume()
    }
}


extension ParseAPI {
    
    
    //MARK: ParseJSON data
    
    private func parseStudentData(studentData: NSDictionary, comletion:(success:Bool)->Void){
        
        guard let sortedData = studentData["results"] as? [[String: AnyObject]] else {
            return
        }
        
        for result in sortedData {
            
            guard let uniqueKey = result["uniqueKey"] as? String else {
                return
            }
            
            guard let firstName = result["firstName"] as? String else {
                return
            }
            
            guard let lastName = result["lastName"] as? String else {
                return
            }
            
            guard let mediaURL = result["mediaURL"] as? String else {
                return
            }
            
            guard let latitude = result["latitude"] as? Double else {
                return
            }
            
            guard let longitude = result["longitude"] as? Double else {
                return
            }
            
            guard let mapString = result["mapString"] as? String else {
                return
            }
            
            let studentInformation = Student(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mediaURL: mediaURL, latitude: latitude, longitude: longitude, mapString: mapString)
            
            StudentInformation.studentArray.append(studentInformation)
        }
        comletion(success: true)
    }

    //MARK: Shared Instance
    
    class func sharedInstance() -> ParseAPI {
        return sharedParse
    }
}