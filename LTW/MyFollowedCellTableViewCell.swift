//  MyFollowedCell.swift
//  LTW
//  Created by Ranjeet Raushan on 09/06/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class MyFollowedCell: UITableViewCell {
@IBOutlet weak var subjctLbl: UILabel!
@IBOutlet weak var sub_subjctLbl: UILabel!
@IBOutlet weak var grdsLbl:  UILabel!
@IBOutlet weak var statusBtn:UIButton!{
        didSet{
            statusBtn.backgroundColor = .clear
            statusBtn.layer.cornerRadius = statusBtn.frame.height / 2
            statusBtn.layer.borderWidth = 1
            statusBtn.layer.borderColor = UIColor.init(hex: "FFB900").cgColor
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
