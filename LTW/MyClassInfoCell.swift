//
//  MyClassInfoCell.swift
//  LTW
//
//  Created by yashoda on 04/05/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import UIKit

class MyClassInfoCell: UITableViewCell {

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
