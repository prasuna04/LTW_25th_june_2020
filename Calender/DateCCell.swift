//
//  DateCCell.swift
//  task7
//
//  Created by vaayoo on 19/01/20.
//  Copyright © 2020 Vaayoo. All rights reserved.
//

import UIKit


class DateCCell: UICollectionViewCell {
    
    @IBOutlet weak var countLbl: UILabel!
//    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var datelbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.countLbl.layer.cornerRadius = (self.countLbl.frame.size.width)/2
        self.countLbl.layer.borderColor = UIColor.white.cgColor
        self.countLbl.layer.borderWidth = 1.0
        self.countLbl.layer.masksToBounds = true
    }
}

