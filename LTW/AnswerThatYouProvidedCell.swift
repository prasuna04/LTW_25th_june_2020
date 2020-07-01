//  AnswerThatYouProvidedCell.swift
//  LTW
//  Created by Ranjeet Raushan on 17/12/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class AnswerThatYouProvidedCell: UITableViewCell {
    @IBOutlet weak var viewContainedImgVw: UIView!
    @IBOutlet weak var imgVw: UIImageView!
    {
        didSet{
            imgVw.setRounded()
            imgVw.clipsToBounds = true
        }
    }
    @IBOutlet weak var viewContainedEvrythingApartFromImg: UIView!
    @IBOutlet weak var subjctLbl: UILabel!
    @IBOutlet weak var datLbl: UILabel!
    @IBOutlet weak var gradeLbl: UILabel!
    @IBOutlet weak var whatIsYourQstnLbl: UILabel!
    @IBOutlet weak var prsonNmLbl: UILabel!
    @IBOutlet weak var prsonTypLbl: UILabel!
    @IBOutlet weak var scholLbl: UILabel!
    @IBOutlet weak var answerLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
