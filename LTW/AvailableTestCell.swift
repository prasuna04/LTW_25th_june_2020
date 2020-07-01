//
//  AvailableTestCell.swift
//  LTW
//
//  Created by yashoda on 27/04/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import UIKit

class AvailableTestCell: UITableViewCell {
    @IBOutlet weak var ratingView: CosmosView!
        @IBOutlet weak var uiContentView: UIView!
        @IBOutlet weak var cardView: CardView!
        @IBOutlet weak var uiImageView: UIImageView!{
            didSet {
                uiImageView.setRounded()
                uiImageView.clipsToBounds = true
            }
        }
        @IBOutlet weak var createdByLabel: UILabel!
        @IBOutlet weak var createdByNameLabel: UILabel!
        
     @IBOutlet weak var titleNameLbl: UILabel!
     @IBOutlet weak var titleNameLabel: UILabel!
        @IBOutlet weak var hightForTheRatingView: NSLayoutConstraint!
        @IBOutlet weak var hightForTheNameBtn: NSLayoutConstraint!
        @IBOutlet weak var widthForTheuiImageView: NSLayoutConstraint!
        
        @IBOutlet weak var topicSubTopicLabel: UILabel!
        @IBOutlet weak var topicSubtopicValueLabel: UILabel!
        @IBOutlet weak var noOFQuesBtn: UIButton!
        @IBOutlet weak var timeBtn: UIButton!
        @IBOutlet weak var applicableBtn: UIButton!
        @IBOutlet weak var testModeBtn: UIButton!
        @IBOutlet weak var testTakenBtn: UIButton!
        @IBOutlet weak var testStartBTn: UIButton!{
            didSet {
                testStartBTn.backgroundColor = .clear
                testStartBTn.layer.cornerRadius = (testStartBTn.frame.height / 2)
                testStartBTn.layer.borderWidth = 1
                testStartBTn.layer.borderColor = UIColor.init(hex: "FFD700").cgColor
            }
        }
     
     @IBOutlet weak var reviewTestBTn: UIButton!{
            didSet {
                reviewTestBTn.backgroundColor = .clear
                reviewTestBTn.layer.cornerRadius = (reviewTestBTn.frame.height / 2)
                reviewTestBTn.layer.borderWidth = 1
                reviewTestBTn.layer.borderColor = UIColor.init(hex: "FFD700").cgColor
            }
        }
     
     
     @IBOutlet weak var leadingToTimeAndMode: NSLayoutConstraint!
     
     
     
    
    
    
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
