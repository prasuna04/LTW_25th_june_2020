//
//  AvailableGroupSignUpTableViewCell.swift
//  LTW
//
//  Created by Vaayoo on 22/04/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import UIKit

class AvailableGroupSignUpTableViewCell: UITableViewCell {
    @IBOutlet weak var noOfParticipants: UILabel!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var topicSubTopic: UILabel!
    @IBOutlet weak var grupCreatedBy: UILabel!
    @IBOutlet weak var createdOn: UILabel!
    @IBOutlet weak var grupImg: UIImageView!
           {
           didSet{
               grupImg.setRounded()
               grupImg.clipsToBounds = true
           }
       }
    @IBOutlet weak var exitgroupBtn: UIButton!{didSet{
        exitgroupBtn.backgroundColor = .clear
        exitgroupBtn.layer.cornerRadius = exitgroupBtn.frame.height / 2
        exitgroupBtn.layer.borderWidth = 1
        exitgroupBtn.setTitle("Subscribe", for: .normal)
        exitgroupBtn.layer.borderColor = UIColor.init(hex: "00994C").cgColor
        }
    }
    @IBOutlet weak var PublicAndPrivate: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
