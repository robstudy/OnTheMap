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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func logout(sender: UIBarButtonItem) {
        UdacityAPI.sharedInstance().logOut()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
