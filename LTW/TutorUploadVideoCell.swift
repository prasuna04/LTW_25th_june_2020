//  TutorUploadVideoCell.swift
//  LTW
//  Created by Vaayoo USA on 04/02/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit

class TutorUploadVideoCell: UITableViewCell {

 @IBOutlet weak var uploadVideoTitleTF: UITextField!
 @IBOutlet weak var uploadVideoBtn: UIButton!
@IBOutlet weak var deleteBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
