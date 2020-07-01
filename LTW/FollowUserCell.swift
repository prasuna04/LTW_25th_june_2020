//  FollowUserCell.swift
//  LTW
//  Created by Chandrashekhar on 04/10/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class FollowUserCell: UITableViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!{
        didSet{
            imgProfile.setRounded()
            imgProfile.clipsToBounds = true
        }
    }
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
