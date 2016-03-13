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
    
    init(uniqueKey: String) {
        self.uniqueKey = uniqueKey
        firstName = ""
        lastName = ""
        mediaURL = ""
        latitude = 0
        longitude = 0
        mapString = ""
    }
    
    init(uniqueKey: String, firstName: String, lastName: String, mediaURL: String, latitude: Double, longitude: Double, mapString: String){
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
    }
}