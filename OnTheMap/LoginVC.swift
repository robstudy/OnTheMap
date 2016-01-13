//
//  ViewController.swift
//  OnTheMap
//
//  Created by Robert Garza on 12/13/15.
//  Copyright © 2015 Robert Garza. All rights reserved.
//

import UIKit

class LoginVC : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let udacityAPI = UdacityAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(string == "\n"){
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if(textField.text == "Email" || textField.text == "Password"){
            textField.text = ""
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func loginVerify(sender: UIButton) {
        guard let emailText = emailTextField.text else {
            return
        }
        guard let passwordText = passwordTextField.text else {
            return
        }
        
        let okPress = UIAlertAction(title: "OK", style: .Default) {(action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        udacityAPI.setErrorChecks(apiCallError: false, internetConnectionError: false)
        udacityAPI.startSession(eText: emailText, pText: passwordText)
        sleep(2)
        if udacityAPI.checkForInternetConnectionError() == true {
            let noConnectionAlert = UIAlertController(title: "Oh No!", message: udacityAPI.errorString, preferredStyle: .Alert)
            noConnectionAlert.addAction(okPress)
            self.presentViewController(noConnectionAlert, animated: true, completion: nil)
            return
        } else if udacityAPI.checkForApiCallError() == true {
            let alert = UIAlertController(title: "Invalid Information", message: udacityAPI.errorString, preferredStyle: .Alert)
            alert.addAction(okPress)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        } else if udacityAPI.checkForApiCallError() == false && udacityAPI.checkForInternetConnectionError() == false {
            self.performSegueWithIdentifier("showTabC", sender: self)
        }
    }
    
        /*
        //Call the Udacity API
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(emailText)\", \"password\": \"\(passwordText)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
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
                if let errorText = String(data: newData, encoding: NSUTF8StringEncoding) where errorText.rangeOfString("error") != nil {
                    var errorString:String?
                    //Show invalid info alerty when 403 error occures
                    if errorText.rangeOfString("403") != nil {
                        errorString = "There was something wrong with your input Email/Password"
                    } else {
                        errorString = errorText
                    }
                    let alert = UIAlertController(title: "Invalid Information", message: errorString, preferredStyle: .Alert)
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
    } */
    
    @IBAction func faceBookLogin(sender: UIButton) {
        
    }
}

