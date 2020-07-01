//  homeFilterCell.swift
//  LTW
//  Created by Ranjeet Raushan on 27/09/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class homeFilterCell: UITableViewCell {
    
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var chkBoxBtn: UIButton!

    @IBOutlet weak var countLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
