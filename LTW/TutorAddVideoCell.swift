//  TutorAddVideoCell.swift
//  LTW
//  Created by Vaayoo USA on 03/02/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit

class TutorAddVideoCell: UITableViewCell {
    
    @IBOutlet weak var videoTitleTF: UITextField!
    @IBOutlet weak var videoLinkTF: UITextField!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
