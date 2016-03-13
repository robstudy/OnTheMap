//
//  ViewController.swift
//  OnTheMap
//

import UIKit

class LoginVC : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var facebookLogInButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var notAMemberButton: UIButton!
    @IBOutlet var LogInUIView: UIView!
    @IBOutlet weak var udacityTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var udacitySignUp = "https://www.udacity.com/account/auth#!/signup"
    
    //MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        buttonLayout()
        setTextViews()
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
        toggleLoading(true)
    
        UdacityAPI.sharedInstance().startSession(eText: emailText, pText: passwordText, completion: {
            (error, completed) in
            if error != nil {
                self.showAlert(error!)
            }
            else if (completed != nil) {
                ParseAPI.sharedInstance().getStudentData({(success) in
                    dispatch_async(dispatch_get_main_queue(), {
                        if success == true {
                            self.toggleLoading(false)
                            self.performSegueWithIdentifier("showTabVC", sender: self)
                        } else {
                            self.showAlert("Call to Parse API was unsuccessful")
                        }
                     })
                })
            }
        })
    }
    
    @IBAction func faceBookLogin(sender: AnyObject) {
        //TODO: Implement Facebook login
    }
    
    @IBAction func becomeAMember(sender: AnyObject) {
        if let url = NSURL(string: udacitySignUp) {
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            } else {
                showAlert("Unable to Connect to Sign Up page")
            }
        }
    }
    
    //MARK: - TextField Delegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//MARK: -

extension LoginVC {
    
    //MARK: - Show Alert
    
    private func showAlert(alertMessage: String) {
        let okPress = UIAlertAction(title: "OK", style: .Default) {(action) in
            self.toggleLoading(false)
            return
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            let noConnectionAlert = UIAlertController(title: "Oh No!", message: alertMessage, preferredStyle: .Alert)
            noConnectionAlert.addAction(okPress)
            self.presentViewController(noConnectionAlert, animated: true, completion: nil)
        })
    }

    //MARK: - UI Functions
    
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
        facebookLogInButton.hidden = true
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
    
    private func toggleLoading(loading: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            if loading {
                self.emailTextField.alpha = 0.5
                self.passwordTextField.alpha = 0.5
                self.loginButton.alpha = 0.5
                self.facebookLogInButton.alpha = 0.5
                self.notAMemberButton.alpha = 0.5
                
                self.emailTextField.enabled = false
                self.passwordTextField.enabled = false
                self.loginButton.enabled = false
                self.facebookLogInButton.enabled = false
                self.notAMemberButton.enabled = false
                self.view.bringSubviewToFront(self.activityIndicator)
                self.activityIndicator.startAnimating()
            } else if !loading {
                self.emailTextField.alpha = 1
                self.passwordTextField.alpha = 1
                self.loginButton.alpha = 1
                self.facebookLogInButton.alpha = 1
                self.notAMemberButton.alpha = 1
                
                self.emailTextField.enabled = true
                self.passwordTextField.enabled = true
                self.loginButton.enabled = true
                self.facebookLogInButton.enabled = true
                self.notAMemberButton.enabled = true
                self.activityIndicator.stopAnimating()
            }
            
        })
        
        
    }
}

