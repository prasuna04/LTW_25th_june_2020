//  TutorRatingAndReviewTableViewCell.swift
//  LTW
//  Created by Vaayoo on 21/02/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit

class TutorRatingAndReviewTableViewCell: UITableViewCell {

       @IBOutlet weak var descriptionLbl: UILabel!
       @IBOutlet weak var subjects: UILabel!
       @IBOutlet weak var grades: UILabel!
       @IBOutlet weak var className: UILabel!
       @IBOutlet weak var name: UILabel!
       @IBOutlet weak var profileImg: UIImageView!{
           didSet{
               profileImg.setRounded()
               profileImg.layer.shadowColor = UIColor.gray.cgColor
               profileImg.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
               profileImg.layer.shadowRadius = 5.0
               profileImg.layer.shadowOpacity = 0.8
           }
       }
       @IBOutlet weak var ratingView: CosmosView!
 override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
