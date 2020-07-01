//  ReviewTestSubmitCell.swift
//  LTW
//  Created by Ranjeet Raushan on 03/10/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class ReviewTestSubmitCell: UITableViewCell {
@IBOutlet weak var quesNoLabel: UILabel!
@IBOutlet weak var questionLabel: UILabel!
@IBOutlet weak var answerTitleLabel: UILabel!
@IBOutlet weak var answerLabel: UILabel!

    @IBOutlet weak var marksLbl: UILabel! /* Added By Yashoda on 28th March 2020 */

    @IBOutlet weak var questionLblHeight: NSLayoutConstraint!
    @IBOutlet weak var answerLblHeight: NSLayoutConstraint!
    
// //   @IBOutlet weak var ContainerView: CardView!
//    @IBOutlet lazy var ContainerView: CardView! = {
//          var temporaryContainerView: CardView = CardView()
//
//          return temporaryContainerView
//      }()
//
    
    
    @IBOutlet weak var editAnswerBtn: UIButton!{
        didSet {
            editAnswerBtn.backgroundColor = .clear
            editAnswerBtn.layer.cornerRadius =  (editAnswerBtn.bounds.height - 10) / 2
            editAnswerBtn.layer.borderWidth = 1
            editAnswerBtn.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
            editAnswerBtn.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        }
    }
@IBOutlet weak var writeAnswerBtn: UIButton!{
    didSet {
        writeAnswerBtn.backgroundColor = .clear
        writeAnswerBtn.layer.cornerRadius =  (editAnswerBtn.bounds.height - 10) / 2
        writeAnswerBtn.layer.borderWidth = 1
        writeAnswerBtn.layer.borderColor = UIColor.init(hex: "48DA00").cgColor
        writeAnswerBtn.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
    }
}

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

