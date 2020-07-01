//  TeachersListCell.swift
//  LTW
//  Created by Ranjeet Raushan on 17/02/20.
//  Copyright © 2020 vaayoo. All rights reserved.

import UIKit

class TeachersListCell: UITableViewCell {

    @IBOutlet weak var tchrImg: UIImageView!
    {
        didSet{
            tchrImg.setRounded()
            tchrImg.clipsToBounds = true
        }
    }
     @IBOutlet weak var hightConstraintetFortheBadges: NSLayoutConstraint! //add by chandra for hideing the badges 
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var tchrFrstNm: UILabel!
    @IBOutlet weak var tchrLastNm: UILabel!
    @IBOutlet weak var schoolLbl: UILabel!
    @IBOutlet weak var prsnTypLabel: UILabel!
    @IBOutlet weak var requestBtn: UIButton!
    {
    didSet {
        requestBtn.backgroundColor = .clear
        requestBtn.layer.borderWidth = 1
        requestBtn.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
        requestBtn.layer.cornerRadius = requestBtn.frame.height/2
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
