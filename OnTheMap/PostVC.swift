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
    
    var createdStudent:Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func locateOnTheMap(sender: UIButton) {
        let geo = CLGeocoder()
        print("clicked")
        if let local = locationInputField.text {
            geo.geocodeAddressString(local, completionHandler: { (placemark, error) in
                if error != nil {
                    print("error")
                    return
                }
                
                if let locationPlaceMark = placemark?[0] {
                    self.mapView.showAnnotations([MKPlacemark(placemark: locationPlaceMark)], animated: true)
                    
                    print(locationPlaceMark.location)
                    
                   /* let lat = (locationPlaceMark.location?.coordinate.latitude)!
                    let long = (locationPlaceMark.location?.coordinate.longitude)!
                    
                    
                    self.createdStudent = Student(uniqueKey: <#T##String#>, firstName: <#T##String#>, lastName: <#T##String#>, mediaURL: <#T##String#>, latitude: lat, longitude: long, mapString: local)*/
                    
                    self.toggleMapView()
                }
            })
        }
    }
    
    @IBAction func submit(sender: UIButton) {
        UdacityAPI.sharedInstance().getUserData()
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
        urlInputField.hidden = false
        locationInputField.hidden = true
    }
    
    
    private func setupFields() {
        urlInputField.hidden = true
        submitButton.hidden = true
    }

}
