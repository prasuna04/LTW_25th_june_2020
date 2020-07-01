//
//  LocalCell.swift
//  LTW
//
//  Created by Vaayoo on 6/4/20.
//  Copyright © 2020 vaayoo. All rights reserved.
//

import UIKit

class LocalCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
