//
//  ViewController.swift
//  OnTheMap
//
//  Created by Robert Garza on 12/13/15.
//  Copyright © 2015 Robert Garza. All rights reserved.
//

import UIKit

class LoginVC : UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var emailTextView: UITextView!
    @IBOutlet weak var passwordTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        emailTextView.delegate = self
        passwordTextView.delegate = self
        passwordTextView.secureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITextViewDelegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if(textView.text == "Email" || textView.text == "Password"){
            textView.text = ""
        }
    }

    //MARK: - IBActions
    
    @IBAction func loginVerify(sender: UIButton) {
        
        //Call the Udacity API
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(emailTextView.text)\", \"password\": \"\(passwordTextView.text)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        //Session
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            //Handle Error if Unable to Connect
            if error != nil {
                //Place UIAlertController on mainthread to prevent crashing
                NSOperationQueue.mainQueue().addOperationWithBlock{
                    let noConnectionAlert = UIAlertController(title: "Oh No!", message: "Unable to Connect to the Internet", preferredStyle: .Alert)
                    let okPress = UIAlertAction(title: "OK", style: .Default){(action) in
                    self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    noConnectionAlert.addAction(okPress)
                    self.presentViewController(noConnectionAlert, animated: true, completion: nil)
                    return
                }
            }
            
            guard let newData = data?.subdataWithRange(NSMakeRange(5, (data?.length)! - 5)) else {
                return
            }
            
            //Perform the error check on the main thread or there will be an error in attempting to present a new UIViewController/AlertViewController
            NSOperationQueue.mainQueue().addOperationWithBlock {
                if let errorText = String(data: newData, encoding: NSUTF8StringEncoding) where errorText.rangeOfString("403") != nil {
                    //Show invalid info alerty when 403 error occures
                    let alert = UIAlertController(title: "Invalid Information", message: "There was something wrong with your input Email/Password", preferredStyle: .Alert)
                    let OkAction = UIAlertAction(title: "OK", style: .Default){(action) in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    alert.addAction(OkAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    self.performSegueWithIdentifier("showTabC", sender: self)
                }
            }
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
    @IBAction func faceBookLogin(sender: UIButton) {
        
    }
}

