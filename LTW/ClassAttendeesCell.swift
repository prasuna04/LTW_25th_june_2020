//  ClassAttendeesCell.swift
//  LTW
//  Created by vaayoo on 10/02/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit

class ClassAttendeesCell: UITableViewCell {

    @IBOutlet weak var noOfAttendees: UILabel!
    @IBOutlet weak var pointsEarned: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var date: UILabel!
   // @IBOutlet weak var timeZone: UILabel!
    @IBOutlet weak var subCategory: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var title: UILabel!
        @IBOutlet weak var reviewButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       reviewButton.backgroundColor = .clear
               reviewButton.layer.cornerRadius = 14
               reviewButton.layer.borderWidth = 1
               reviewButton.layer.borderColor = UIColor.green.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        // Configure the view for the selected state
    }

   
    
}
