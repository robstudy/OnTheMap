//
//  StudentTableCell.swift
//  OnTheMap
//

import UIKit

class StudentTableCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var urlLabel: UITextField!
    
    func configureStudentCell(studentData: Student) {
        nameLabel.text = studentData.firstName + " " + studentData.lastName
        urlLabel.text = studentData.mediaURL
    }
}
