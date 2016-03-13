//
//  StudentInformation.swift
//  OnTheMap
//
import Foundation

struct StudentInformation {
    internal static var studentArray = [Student]()
    
    private var storedDictionary:NSDictionary?
    
    init(completedDictionary: NSDictionary) {
        storedDictionary = completedDictionary
    }
    
    func returnDictionary() -> NSDictionary {
        return storedDictionary!
    }
}