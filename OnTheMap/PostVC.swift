//
//  PostVC.swift
//  OnTheMap
//

import UIKit
import MapKit

class PostVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var urlInputField: UITextField!
    @IBOutlet weak var locationInputField: UITextField!
    @IBOutlet weak var onTheMapButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var pushOrPut = ""
    var update = false
    var objectId = ""
    
    private var studentInformation:(firstName: String, lastName: String, userKey: String)?
    private var studentLocationData: (latitude: Double, longitude: Double, mapString: String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBActions
    
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func locateOnTheMap(sender: UIButton) {
        let geo = CLGeocoder()
        if let local = locationInputField.text {
            geo.geocodeAddressString(local, completionHandler: { (placemark, error) in
                if error != nil {
                    self.showAlert("Invalid location input", header: "An error occured!", addButton: nil, addReturnButton: true)
                    return
                }
                
                if let locationPlaceMark = placemark?[0] {
                    self.mapView.showAnnotations([MKPlacemark(placemark: locationPlaceMark)], animated: true)
                    
                    UdacityAPI.sharedInstance().getUserData()
                    
                    let lat = (locationPlaceMark.location?.coordinate.latitude)!
                    let long = (locationPlaceMark.location?.coordinate.longitude)!
                    
                    self.studentLocationData = (lat, long, local)
                    
                    self.toggleMapView()
                }
            })
        }
    }
    
    @IBAction func submit(sender: UIButton) {
        toggleActivityView(true)
        studentInformation = UdacityAPI.sharedInstance().studentInformation

        guard let submitUrl = urlInputField.text else {
            return
        }
        
        let submittedStudentDictionary = ["uniqueKey": studentInformation!.userKey,
            "firstName": studentInformation!.firstName,
            "lastName": studentInformation!.lastName,
            "mediaURL": submitUrl,
            "latitude": studentLocationData!.latitude,
            "longitude": studentLocationData!.longitude,
            "mapString": studentLocationData!.mapString
        ]
        
        let submitttedStudent = Student(data: submittedStudentDictionary)
        
        ParseAPI.sharedInstance().postStudentData(submitttedStudent, requestType: pushOrPut, updateOldData: update, objectId: objectId, completion:{
            (error, success) in
            if error != nil {
                self.showAlert(error!, header: "Uhoh!", addButton: nil, addReturnButton: true)
                return
            }
            
            if success {
                let dismissSelf = UIAlertAction(title: "Return", style: .Default, handler: {(action) in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                self.showAlert("Information has been updated.", header: "Success!", addButton: dismissSelf, addReturnButton: false)
            }
        })
    }
    
    //MARK: - Alert
    
    private func showAlert(alertMessage: String, header: String, addButton: UIAlertAction?, addReturnButton: Bool) {
        
        let returnPress = UIAlertAction(title: "Return", style: .Default) { (action) in
            self.toggleActivityView(false)
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
    
    //MARK - Toggle Views

    private func toggleActivityView(on: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            if on {
                self.activityView.startAnimating()
                self.view.bringSubviewToFront(self.activityView)
                self.submitButton.enabled = false
            } else {
                self.activityView.stopAnimating()
                self.submitButton.enabled = true
            }
        })
    }
    
    private func toggleMapView() {
        middleView.hidden = true
        bottomView.hidden = true
        onTheMapButton.hidden = true
        submitButton.hidden = false
        submitButton.layer.cornerRadius = 7
        urlInputField.hidden = false
        locationInputField.hidden = true
    }
    
    //MARK: - TextField Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - Set up Fields
    
    private func setupFields() {
        locationInputField.delegate = self
        urlInputField.delegate = self
        urlInputField.hidden = true
        submitButton.hidden = true
        onTheMapButton.layer.cornerRadius = 7
    }
}
