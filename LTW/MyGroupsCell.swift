// MyGroupsCell.swift
// LTW
// Created by Ranjeet Raushan on 26/07/19.
// Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class MyGroupsCell: UITableViewCell {
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var hightForTheMessageView: NSLayoutConstraint!
    @IBOutlet weak var noOfParticipants: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var hightForTheDeleteBtn: NSLayoutConstraint!
    @IBOutlet weak var hightForTheEditBtn: NSLayoutConstraint!
    @IBOutlet weak var hightForTheExitBtn: NSLayoutConstraint!
    @IBOutlet weak var groupInfo: UIButton!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var topicSubTopic: UILabel!
    @IBOutlet weak var grupCreatedBy: UILabel!
    @IBOutlet weak var createdOn: UILabel!
    @IBOutlet weak var grupEditBtn: UIButton!
    @IBOutlet weak var grupDelteBtn: UIButton!
    @IBOutlet weak var grupImg: UIImageView!
        {
        didSet{
            grupImg.setRounded()
            grupImg.clipsToBounds = true
        }
    }
    @IBOutlet weak var DiscussionVC: UIButton!
    @IBOutlet weak var grupCreatedByLblHight: NSLayoutConstraint!
    @IBOutlet weak var PublicAndPrivate: UIButton!

    @IBOutlet weak var exitgroupBtn: UIButton!{didSet{
        exitgroupBtn.backgroundColor = .clear
        exitgroupBtn.layer.cornerRadius = exitgroupBtn.frame.height / 2
        exitgroupBtn.layer.borderWidth = 1
        exitgroupBtn.setTitle("ExitGroup", for: .normal)
        exitgroupBtn.layer.borderColor = UIColor.init(hex: "FFAE00").cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
