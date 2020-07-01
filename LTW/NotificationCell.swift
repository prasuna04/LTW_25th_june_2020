//  NotificationCell.swift
//  LTW
//  Created by manjunath Hindupur on 27/08/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet {
            profileImageView.setRounded()
        }
    }
    @IBOutlet weak var activeLbl: UILabel!{didSet{
    activeLbl.layer.cornerRadius = activeLbl.frame.width/2
    activeLbl.layer.masksToBounds = true
    }}
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageTimeLabler: UILabel!
    @IBOutlet weak var checkBox: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
