//
//  Student.swift
//  OnTheMap
//

import Foundation

struct Student {
    
    let uniqueKey: String
    let firstName: String
    let lastName: String
    var mediaURL: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    
    init(data: NSDictionary) {
        uniqueKey = data["uniqueKey"] as! String
        firstName = data["firstName"] as! String
        lastName = data["lastName"] as! String
        mediaURL = data["mediaURL"] as! String
        latitude = data["latitude"] as! Double
        longitude = data["longitude"] as! Double
        mapString = data["mapString"] as! String
    }
}