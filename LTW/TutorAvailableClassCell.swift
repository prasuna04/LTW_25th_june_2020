//  TutorAvailableClassCell.swift
//  LTW
//  Created by Ranjeet Raushan on 23/02/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit

class TutorAvailableClassCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var subSubjectNameLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pointsCharegedLabel: UILabel!
    @IBOutlet weak var numberOfAttendeesLabel: UILabel!
    @IBOutlet weak var publicBtn: UIButton!
   
    @IBOutlet weak var SsubscribeBtn: UIButton!{
        didSet {
            SsubscribeBtn.backgroundColor = .clear
            SsubscribeBtn.layer.cornerRadius = (SsubscribeBtn.bounds.height - 10) / 2
            SsubscribeBtn.layer.borderWidth = 1
            SsubscribeBtn.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
            SsubscribeBtn.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        }
    }
       @IBOutlet weak var nameLabel: UILabel!
       @IBOutlet weak var profileImg: UIImageView!
       @IBOutlet weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
