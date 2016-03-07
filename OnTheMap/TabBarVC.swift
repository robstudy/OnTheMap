//
//  TabBarVC.swift
//  OnTheMap
//
//  Created by Robert Garza on 3/6/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
    
    var httpMethod = ""

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
    
    
    @IBAction func postLocation(sender: AnyObject) {
        let studentKey = UdacityAPI.sharedInstance().studentKey
        ParseAPI.sharedInstance().queryParse(studentKey, completion: { (httpMethod, objId) in
            self.httpMethod = httpMethod
            if objId != nil {
                let okButton = UIAlertAction(title: "OK", style: .Default) { (action) in
                    self.performSegueWithIdentifier("postVC", sender: self)
                }
                
                self.showAlert("Would you like to overwrite previous data?", header: "It appears you already have posted information", addButton: okButton, addCancelButton: true)
            } else {
                self.performSegueWithIdentifier("postVC", sender: self)
            }
        })
        print(self.httpMethod)
        
    }
    
    
    @IBAction func refreshData(sender: AnyObject) {
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "postVC") {
            let postViewController:PostVC = segue.destinationViewController as! PostVC
            postViewController.pushOrPut = httpMethod
        }
    }
    
    private func showAlert(alertMessage: String, header: String, addButton: UIAlertAction?, addCancelButton: Bool) {
        
        let cancelPress = UIAlertAction(title: "Cancel", style: .Default) { (action) in
            return
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            let theAlert = UIAlertController(title: header, message: alertMessage, preferredStyle: .Alert)
            if addButton != nil {
                theAlert.addAction(addButton!)
            }
            if addCancelButton {
                theAlert.addAction(cancelPress)
            }
            self.presentViewController(theAlert, animated: true, completion: nil)
        })
    }


}
