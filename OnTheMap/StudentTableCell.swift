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
    
    func configureStudentCell(studentData: Student) {
        nameLabel.text = studentData.firstName + " " + studentData.lastName
    }
}
