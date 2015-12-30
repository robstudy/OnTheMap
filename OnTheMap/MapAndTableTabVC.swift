//
//  MapAndTableTabVC.swift
//  OnTheMap
//
//  Created by Robert Garza on 12/28/15.
//  Copyright © 2015 Robert Garza. All rights reserved.
//

import UIKit
import MapKit

class MapAndTableTabVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
