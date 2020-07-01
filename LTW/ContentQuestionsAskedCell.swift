//  ContentQuestionsAskedCell.swift
//  LTW
//  Created by Ranjeet Raushan on 31/05/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class ContentQuestionsAskedCell: UITableViewCell {
    @IBOutlet weak var questionsAskedLbl:UILabel!
    
    @IBOutlet weak var askedOnDateLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
     @IBOutlet weak var deltBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
