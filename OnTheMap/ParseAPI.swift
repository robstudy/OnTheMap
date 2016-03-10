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
    
    //MARK: GET
    
    func getStudentData(completion: (success:Bool)->Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: ParseStrings.url)!)
        request.addValue(ParseStrings.id, forHTTPHeaderField: ParseStrings.appID)
        request.addValue(ParseStrings.key, forHTTPHeaderField: ParseStrings.keyID)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completion(success: false)
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
            parseURL = ParseStrings.url + "/" + objectId!
        } else {
            parseURL = ParseStrings.url
        }
        let url = NSURL(string: parseURL)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = requestType
        request.addValue(ParseStrings.id, forHTTPHeaderField: ParseStrings.appID)
        request.addValue(ParseStrings.key, forHTTPHeaderField: ParseStrings.keyID)
        request.addValue(ParseStrings.valueJson, forHTTPHeaderField: ParseStrings.content)
        
        request.HTTPBody = "{\"uniqueKey\": \"\(studentInformation.uniqueKey)\", \"firstName\": \"\(studentInformation.firstName)\", \"lastName\": \"\(studentInformation.lastName)\",\"mapString\": \"\(studentInformation.mapString)\", \"mediaURL\": \"\(studentInformation.mediaURL)\",\"latitude\": \(studentInformation.latitude), \"longitude\": \(studentInformation.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completion(error: "Could not complete request", success: false)
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
    
    //MARK: Query
    
    func queryParse(studentKey: String, completion: (httpMethod: String?, objId: String?, error: String?) ->Void) {
        let urlString = ParseStrings.url + "?where=%7B%22uniqueKey%22%3A%22\(studentKey)%22%7D"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.addValue(ParseStrings.id, forHTTPHeaderField: ParseStrings.appID)
        request.addValue(ParseStrings.key, forHTTPHeaderField: ParseStrings.keyID)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { /* Handle error */
                completion(httpMethod: nil, objId: nil, error: "Could not complete query")
                return
            }
            
            guard let queryData = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary else {
                return
            }
            
            guard let queryObjectId = queryData?["results"]?[0]["objectId"] as? String else {
                return
            }
            
            var httpMethod = ""
            
            if queryObjectId != "" {
                httpMethod = ParseStrings.httpPut
            } else {
                httpMethod = ParseStrings.httpPush
            }

            completion(httpMethod: httpMethod, objId: queryObjectId, error: nil)
        }
        task.resume()
    }
}


extension ParseAPI {
    
    
    //MARK: ParseJSON data
    
    private func parseStudentData(studentData: NSDictionary, comletion:(success:Bool)->Void){
        
        guard let sortedData = studentData["results"] as? [[String: AnyObject]] else {
            comletion(success: false)
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

    //MARK: Singleton
    
    class func sharedInstance() -> ParseAPI {
        return sharedParse
    }
}