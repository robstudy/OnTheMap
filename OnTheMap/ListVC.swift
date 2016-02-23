//
//  ListVC.swift
//  OnTheMap
//
//  Created by Robert Garza on 1/3/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import UIKit

class ListVC: UITableViewController {
    
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
