//
//  TabBarVC.swift
//  OnTheMap
//
//  Created by Robert Garza on 3/6/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
    
    private var httpMethod = ""
    private var objectID = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logout(sender: AnyObject) {
        UdacityAPI.sharedInstance().logOut()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func refresh(sender: AnyObject) {
        StudentInformation.studentArray = []
        ParseAPI.sharedInstance().getStudentData({(completion) in
            dispatch_async(dispatch_get_main_queue(), {
                if completion {
                    self.refreshViews()
                } else {
                    self.showAlert("Unable to reload data", header: "Error", addButton: nil, addReturnButton: true)
                }
            })
        })
    }
    
    private func refreshViews() {
        if self.selectedIndex == 0 {
            let mapVC: MapVC = self.selectedViewController as! MapVC
            mapVC.mapView.removeAnnotations(mapVC.mapView.annotations)
            mapVC.viewDidAppear(true)
        } else if self.selectedIndex == 1 {
            let listVC = self.selectedViewController as! ListVC
            listVC.tableView.reloadData()
        }
    }
    
    
    @IBAction func postLocation(sender: AnyObject) {
        let studentKey = UdacityAPI.sharedInstance().studentKey
        ParseAPI.sharedInstance().queryParse(studentKey, completion: { (httpMethod, objId, error) in
            
            if error != nil {
                self.showAlert("", header: error!, addButton: nil, addReturnButton: true)
            }
            
            if httpMethod != nil {
                self.httpMethod = httpMethod!
            }
            
            if objId != nil {
                self.objectID = objId!
                let okButton = UIAlertAction(title: "OK", style: .Default) { (action) in
                    self.performSegueWithIdentifier("postVC", sender: self)
                }
                
                self.showAlert("Would you like to overwrite previous data?", header: "It appears you already have posted information", addButton: okButton, addReturnButton: true)
            } else {
                self.performSegueWithIdentifier("postVC", sender: self)
            }
        })
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "postVC") {
            let postViewController:PostVC = segue.destinationViewController as! PostVC
            postViewController.pushOrPut = httpMethod
            if (httpMethod == "PUT") {
                postViewController.objectId = self.objectID
                postViewController.update = true
            }
        }
    }
    
    private func showAlert(alertMessage: String, header: String, addButton: UIAlertAction?, addReturnButton: Bool) {
        
        let returnPress = UIAlertAction(title: "Return", style: .Default) { (action) in
            return
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            let theAlert = UIAlertController(title: header, message: alertMessage, preferredStyle: .Alert)
            if addButton != nil {
                theAlert.addAction(addButton!)
            }
            if addReturnButton {
                theAlert.addAction(returnPress)
            }
            self.presentViewController(theAlert, animated: true, completion: nil)
        })
    }
}
