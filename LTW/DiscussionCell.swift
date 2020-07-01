//  DiscussionCell.swift
//  LTW
//  Created by Vaayoo on 24/09/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class DiscussionCell: UITableViewCell {
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var hightForTheCountLbl: NSLayoutConstraint!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
