//
//  APIStrings.swift
//  OnTheMap
//
//  Created by Robert Garza on 3/9/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import Foundation

extension ParseAPI {
    
    struct ParseStrings {
        static let url = "https://api.parse.com/1/classes/StudentLocation"
        static let id = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let key = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let appID = "X-Parse-Application-Id"
        static let keyID = "X-Parse-REST-API-Key"
        static let valueJson = "application/json"
        static let content = "Content-Type"
        static let httpPut = "PUT"
        static let httpPost = "POST"
    }
}

extension UdacityAPI {
    
    struct UdacityStrings {
        static let url = "https://www.udacity.com/api/session"
        static let queryUrl = "https://www.udacity.com/api/users/"
        static let valueJson = "application/json"
        static let accept = "Accept"
        static let content = "Content-Type"
        static let cookieName = "XSRF-TOKEN"
        static let cookieHeader = "X-XSRF-TOKEN"
        static let httpPost = "POST"
        static let httpDelete = "DELETE"
    }
    
    struct Errors {
        static let invalidCreditials = "Invalid user credentials"
        static let connection = "Unable to connect to the internet"
    }
}