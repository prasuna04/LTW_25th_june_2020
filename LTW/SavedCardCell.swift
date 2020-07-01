//
//  SavedCardCell.swift
//  BidToBring
//
//  Created by vaayoo on 10/10/18.
//  Copyright © 2018 vaayoo. All rights reserved.
//

import UIKit

class SavedCardCell: UITableViewCell {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var cvvUnderlineView: UIView!
    
    @IBOutlet weak var quesmarkBtnUnderlineView: UIView!
    @IBOutlet weak var QuesMarkBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        QuesMarkBtn.layer.cornerRadius = QuesMarkBtn.frame.width / 2
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
