//
//  PostVC.swift
//  OnTheMap
//
//  Created by Robert Garza on 2/24/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import UIKit
import MapKit

class PostVC: UIViewController {
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var urlInputField: UITextField!
    @IBOutlet weak var locationInputField: UITextField!
    @IBOutlet weak var onTheMapButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var pushOrPut = ""
    
    private var studentInformation:(firstName: String, lastName: String, userKey: String)?
    private var studentLocationData: (latitude: Double, longitude: Double, mapString: String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFields()
        print("\(pushOrPut)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: UIButton) {
        print("\(pushOrPut)")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func locateOnTheMap(sender: UIButton) {
        let geo = CLGeocoder()
        if let local = locationInputField.text {
            geo.geocodeAddressString(local, completionHandler: { (placemark, error) in
                if error != nil {
                    print("error")
                    return
                }
                
                if let locationPlaceMark = placemark?[0] {
                    self.mapView.showAnnotations([MKPlacemark(placemark: locationPlaceMark)], animated: true)
                    
                    UdacityAPI.sharedInstance().getUserData()
                    
                    let lat = (locationPlaceMark.location?.coordinate.latitude)!
                    let long = (locationPlaceMark.location?.coordinate.longitude)!
                    
                    self.studentLocationData = (lat, long, local)
                    
                    print(self.studentLocationData)
                    
                    self.toggleMapView()
                }
            })
        }
    }
    
    @IBAction func submit(sender: UIButton) {
        activityView.startAnimating()
        view.bringSubviewToFront(activityView)
        studentInformation = UdacityAPI.sharedInstance().studentInformation
        if studentInformation != nil {
            print("Student Information: \(studentInformation!.firstName) \(studentInformation!.lastName) Key: \(studentInformation!.userKey)")
        }
        
        guard let submitUrl = urlInputField.text else {
            return
        }
        
        let submitttedStudent = Student(uniqueKey: studentInformation!.userKey, firstName: studentInformation!.firstName, lastName: studentInformation!.lastName, mediaURL: submitUrl, latitude: studentLocationData!.latitude, longitude: studentLocationData!.longitude, mapString: studentLocationData!.mapString)
        
        print(submitttedStudent)
    }
    
    private func toggleMapView() {
        middleView.hidden = true
        bottomView.hidden = true
        onTheMapButton.hidden = true
        onTheMapButton.enabled = false
        submitButton.hidden = false
        submitButton.layer.cornerRadius = 7
        submitButton.layer.borderWidth = 3
        submitButton.layer.borderColor = UIColor.blackColor().CGColor
        submitButton.layer.bounds.size.height = 50
        submitButton.layer.bounds.size.width = 100
        urlInputField.hidden = false
        locationInputField.hidden = true
    }
    
    private func setupFields() {
        urlInputField.hidden = true
        submitButton.hidden = true
    }
}
