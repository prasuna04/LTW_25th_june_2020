//  GroupSearchTableViewCell.swift
//  LTW
//  Created by vaayoo on 14/10/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class GroupSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var joinagroup: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
