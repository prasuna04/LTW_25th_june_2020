//
//  ClassesAttended.swift
//  LTW
//
//  Created by yashoda on 11/05/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import UIKit

class ClassesAttended: UITableViewCell {
    
      @IBOutlet weak var testTitleLabel: UILabel!
      
      @IBOutlet weak var subjectNameLabel: UILabel!
      @IBOutlet weak var ratingView: CosmosView! /* Added By Chandra on 10th Jan 2020 */
      @IBOutlet weak var subSubjectNameLabel: UILabel!
      @IBOutlet weak var timeZoneLabel: UILabel!
      @IBOutlet weak var dateLabel: UILabel!
      @IBOutlet weak var timeLabel: UILabel!
      @IBOutlet weak var pointsCharegedLabel: UILabel!
      @IBOutlet weak var numberOfAttendeesLabel: UILabel!
      @IBOutlet weak var publicBtn: UIButton!
      @IBOutlet weak var editClassBtn: UIButton!
      @IBOutlet weak var deleteClassBtn: UIButton!
      @IBOutlet weak var nsLayoutConstrintStartBtn: NSLayoutConstraint! /* Added By Yashoda on 16th April 2020 */
       @IBOutlet weak var infoClassBtn: UIButton!
      @IBOutlet weak var gradesLblValue: UILabel!
          @IBOutlet weak var nameLabel: UILabel!
       @IBOutlet weak var profileImg: UIImageView!
       @IBOutlet weak var profileVwHight:NSLayoutConstraint!
       @IBOutlet weak var subView: UIView!
    
    
    
    

     @IBOutlet weak var rateAndReviewBTn: UIButton!{
           didSet {
               rateAndReviewBTn.backgroundColor = .clear
               rateAndReviewBTn.layer.cornerRadius = (rateAndReviewBTn.frame.height / 2)
               rateAndReviewBTn.layer.borderWidth = 1
               rateAndReviewBTn.layer.borderColor = UIColor.init(hex: "7DC20B").cgColor
           }
       }
       @IBOutlet weak var notAttendedBTn: UIButton!
//        {
//           didSet {
//               notAttendedBTn.backgroundColor = .clear
//               notAttendedBTn.layer.cornerRadius = (notAttendedBTn.frame.height / 2)
//               notAttendedBTn.layer.borderWidth = 1
//              notAttendedBTn.layer.borderColor = UIColor.init(hex: "7DC20B").cgColor
//           }
//       }
//    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
