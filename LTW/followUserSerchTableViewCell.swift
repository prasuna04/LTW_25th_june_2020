//  followUserSerchTableViewCell.swift
//  LTW
//  Created by vaayoo on 10/10/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class followUserSerchTableViewCell: UITableViewCell {

    @IBOutlet weak var followUnfollowBtn: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
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
