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
    
    var session = NSURLSession.sharedSession()
    let parseID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let parseKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    let parseURLString = "https://api.parse.com/1/classes/StudentLocation"
    let parsePOSTURLString = "https://api.parse.com/1/classes/StudentLocation/8ZExGR5uX8"
    let parseAppIDField = "X-Parse-Application-Id"
    let parseKeyIDField = "X-Parse-REST-API-Key"
    
    var studentData: NSDictionary?
    var studentArray: [Student] = []
    
    func getStudentData() {
        let request = NSMutableURLRequest(URL: NSURL(string: parseURLString)!)
        request.addValue(parseID, forHTTPHeaderField: parseAppIDField)
        request.addValue(parseKey, forHTTPHeaderField: parseKeyIDField)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("error")
                return
            }
            self.studentData = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            
            self.parseStudentData()
        }
        task.resume()
    }
    
    //MARK: ParseJSON data
    
    private func parseStudentData(){
        
        guard let sortedData = studentData!["results"] as? [[String: AnyObject]] else {
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
    
    func postStudentData() {
        let url = NSURL(string: parsePOSTURLString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue(parseID, forHTTPHeaderField: parseAppIDField)
        request.addValue(parseKey, forHTTPHeaderField: parseKeyIDField)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.HTTPBody =
        
    }
    
    
    //MARK: Shared Instance
    
    class func sharedInstance() -> ParseAPI {
        return sharedParse
    }
}