//  LikesTableViewCell.swift
//  LTW
//  Created by vaayoo on 11/10/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class LikesTableViewCell: UITableViewCell {
    @IBOutlet weak var followUnfollowBtn: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileview: UIImageView!{didSet{
        profileview.setRounded()
        }}
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
