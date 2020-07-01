//  ContentQuestionsFollowedCell.swift
//  LTW
//  Created by Ranjeet Raushan on 10/06/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class ContentQuestionsFollowedCell: UITableViewCell {
    @IBOutlet weak var questionsAskedLbl:UILabel!
    
    @IBOutlet weak var askedOnDateLbl: UILabel!
    
    @IBOutlet weak var contntUnfollowBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
