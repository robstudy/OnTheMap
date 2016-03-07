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
    @IBOutlet weak var facebookLogInButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var LogInUIView: UIView!
    @IBOutlet weak var udacityTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    //MARK: Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        buttonLayout()
        setTextViews()
        ParseAPI.sharedInstance().getStudentData(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Login Methods
    
    @IBAction func loginVerify(sender: AnyObject) {
        guard let emailText = emailTextField.text else {
            return
        }
        guard let passwordText = passwordTextField.text else {
            return
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.view.bringSubviewToFront(self.activityIndicator)
            self.activityIndicator.startAnimating()
        })
    
        UdacityAPI.sharedInstance().startSession(eText: emailText, pText: passwordText, completion: {
            (error, completed) in
            if error != nil {
                self.showAlert(error!)
            } else if (completed != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicator.stopAnimating()
                    self.performSegueWithIdentifier("showTabVC", sender: self)
                })
            }
        })
    }
    
    @IBAction func faceBookLogin(sender: UIButton) {
        
    }
    
    //MARK: - TextField Delegate Methods
    
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
}

extension LoginVC {
    
    //MARK: -Show Alert
    
    private func showAlert(alertMessage: String) {
        let okPress = UIAlertAction(title: "OK", style: .Default) {(action) in
            dispatch_async(dispatch_get_main_queue(), {
                self.activityIndicator.stopAnimating()
            })
            return
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            let noConnectionAlert = UIAlertController(title: "Oh No!", message: alertMessage, preferredStyle: .Alert)
            noConnectionAlert.addAction(okPress)
            self.presentViewController(noConnectionAlert, animated: true, completion: nil)
        })
    }

    //MARK: - Load View
    
    private func configureBackground() {
        /**
         Adding Gradients to views --
         http://stackoverflow.com/questions/23074539/programmatically-create-a-uiview-with-color-gradient
         **/
        
        let gradientLayerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = gradientLayerView.bounds
        gradient.colors = [UIColor.orangeColor().CGColor, UIColor.redColor().CGColor]
        gradientLayerView.layer.insertSublayer(gradient, atIndex: 0)
        LogInUIView.layer.insertSublayer(gradientLayerView.layer, atIndex: 0)
    }
    
    private func buttonLayout() {
        //Button border radius = 7
        emailTextField.layer.cornerRadius = 7
        passwordTextField.layer.cornerRadius = 7
        
        loginButton.layer.cornerRadius = 7
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.blackColor().CGColor
        
        facebookLogInButton.layer.cornerRadius = 7
        facebookLogInButton.layer.borderWidth = 1
        facebookLogInButton.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    private func setTextViews() {
        //TextView
        udacityTextView.editable = false
        udacityTextView.selectable = false
        udacityTextView.textColor = UIColor.whiteColor()
        
        //Set button delegates
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
}

