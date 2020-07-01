//  HomeCell.swift
//  LTW
//  Created by Ranjeet Raushan on 21/04/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class HomeCell: UITableViewCell {
    
    
    @IBOutlet weak var personImgVw: UIImageView!{
        didSet{
            personImgVw.setRounded()
            personImgVw.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var answerPointsLbl: UILabel!
    @IBOutlet weak var subjctLbl: UILabel!
    @IBOutlet weak var gradLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var whatIsUrQustnLbl: UILabel!
    @IBOutlet weak var personNameLbl: UILabel!
    @IBOutlet weak var scholLbl: UILabel!
    @IBOutlet weak var answerLbl: UILabel!
    @IBOutlet weak var prsnTyp: UILabel!
    @IBOutlet weak var upVoteBtn: UIButton!
   // @IBOutlet weak var downVoteBtn: UIButton! /* Don't delete downvote functionality , future might reuse somewhere else */
    @IBOutlet weak var commntBtn: UIButton!
    @IBOutlet weak var viewsBtn: UIButton! // views(seen) btn cell
    @IBOutlet weak var spamBtn: UIButton!
    @IBOutlet weak var viewRelatedToImage: UIView!
    //viewRelatedToUpperPartOfCell
    @IBOutlet weak var viewRelatedToUpperPartOfCell: UIView!
    @IBOutlet weak var viewRelatedToAnswers: UIView!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var answerVWHgt: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib() 
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
