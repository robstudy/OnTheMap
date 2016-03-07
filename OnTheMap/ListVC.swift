//
//  ListVC.swift
//  OnTheMap
//
//  Created by Robert Garza on 1/3/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import UIKit

class ListVC: UITableViewController {
    
    private let students = ParseAPI.sharedInstance().studentArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Alert
    
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
    
    
    //MARK: TableView Functions
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell", forIndexPath: indexPath) as! StudentTableCell
        let studentLocation = students[indexPath.item]
        cell.configureStudentCell(studentLocation)
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let studentMediaURL = students[indexPath.row].mediaURL
        
        if let mediaURL = NSURL(string: studentMediaURL) {
            if UIApplication.sharedApplication().canOpenURL(mediaURL) {
                UIApplication.sharedApplication().openURL(mediaURL)
            } else {
               showAlert()
            }
        }
    }
    
}
