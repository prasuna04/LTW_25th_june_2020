//  LinkTableViewCell.swift
//  Created by Vaayoo on 18/02/20.

import UIKit

class LinkTableViewCell: UITableViewCell {
    @IBOutlet weak var thumnailImg:UIImageView!
    @IBOutlet weak var playicon:UIImageView!
    @IBOutlet weak var linkTitle:UILabel!
    @IBOutlet weak var deleteBtn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
