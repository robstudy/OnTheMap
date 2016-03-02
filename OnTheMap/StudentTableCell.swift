//
//  StudentTableCell.swift
//  OnTheMap
//
//  Created by Robert Garza on 2/23/16.
//  Copyright © 2016 Robert Garza. All rights reserved.
//

import UIKit

class StudentTableCell: UITableViewCell {
    
    //MARK: Outlets

    @IBOutlet weak var nameLabel: UITextView!
    @IBOutlet weak var urlLabel: UITextView!
    
    func configureStudentCell(studentData: Student) {
        nameLabel.text = studentData.firstName + " " + studentData.lastName
        urlLabel.text = studentData.mediaURL
        urlLabel.scrollEnabled = false
        nameLabel.scrollEnabled = false
    }
}