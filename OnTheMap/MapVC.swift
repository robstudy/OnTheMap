//
//  MapVC.swift
//  OnTheMap
//
//  Created by Robert Garza on 12/28/15.
//  Copyright © 2015 Robert Garza. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        addPins()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Similiar to cellForRow
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.blueColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    //Tap to open URL
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let mediaURL = NSURL(string: ((view.annotation?.subtitle)!)!) {
                if UIApplication.sharedApplication().canOpenURL(mediaURL) {
                    UIApplication.sharedApplication().openURL(mediaURL)
                } else {
                    showAlert()
                }
            }
        }
    }
}

extension MapVC {
    private func showAlert() {
        let okPress = UIAlertAction(title: "OK", style: .Default) {(action) in
            return
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            let noConnectionAlert = UIAlertController(title: "Oh No!", message: "Invalid URL", preferredStyle: .Alert)
            noConnectionAlert.addAction(okPress)
            self.presentViewController(noConnectionAlert, animated: true, completion: nil)
        })
    }
    
    //MARK: Add Pins
    private func addPins() {
        //annotations for mapview
        var annotations = [MKPointAnnotation]()
        
        for locations in ParseAPI.sharedInstance().studentArray {
            
            //get lon and lat values
            let lat = CLLocationDegrees(locations.latitude)
            let long = CLLocationDegrees(locations.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = locations.firstName
            let last = locations.lastName
            let mediaURL = locations.mediaURL
            
            
            //Create coordinate, title, and subtitle
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            //Place in annotations array
            annotations.append(annotation)
        }
        //Add annotations to maps
        mapView.addAnnotations(annotations)
    }
}