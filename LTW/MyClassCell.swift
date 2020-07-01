//  MyClassCell.swift
//  LTW
//  Created by Ranjeet Raushan on 18/10/19.
//  Copyright © 2019 vaayoo. All rights reserved.

class MyClassCell: UITableViewCell {
    
    @IBOutlet weak var testTitleLabel: UILabel!
    
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView! /* Added By Chandra on 10th Jan 2020 */
    @IBOutlet weak var subSubjectNameLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pointsCharegedLabel: UILabel!
    @IBOutlet weak var numberOfAttendeesLabel: UILabel!
    @IBOutlet weak var publicBtn: UIButton!
    @IBOutlet weak var editClassBtn: UIButton!
    @IBOutlet weak var deleteClassBtn: UIButton!
    @IBOutlet weak var nsLayoutConstrintStartBtn: NSLayoutConstraint! /* Added By Yashoda on 16th April 2020 */
     @IBOutlet weak var infoClassBtn: UIButton!
    @IBOutlet weak var gradesLblValue: UILabel!
   @IBOutlet weak var nsLayoutConstraintWhiteBoardLeft: NSLayoutConstraint!
    @IBOutlet weak var startBtn: UIButton!{
        didSet {
            //startBtn.backgroundColor = .clear//60A200
            startBtn.layer.cornerRadius = (startBtn.bounds.height - 10) / 2
            startBtn.layer.borderWidth = 1
            startBtn.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
            startBtn.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        }
    }
    @IBOutlet weak var WhiteBoard: UIButton!{
        didSet {
            WhiteBoard.backgroundColor = .clear
            WhiteBoard.layer.cornerRadius = (WhiteBoard.bounds.height - 10) / 2
            WhiteBoard.layer.borderWidth = 1
            WhiteBoard.layer.borderColor = UIColor.init(hex: "7DC20B").cgColor
            WhiteBoard.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        }
    }
    @IBOutlet weak var SsubscribeBtn: UIButton!{
        didSet {
            SsubscribeBtn.backgroundColor = .clear
            SsubscribeBtn.layer.cornerRadius = (SsubscribeBtn.bounds.height - 10) / 2
            SsubscribeBtn.layer.borderWidth = 1
            SsubscribeBtn.layer.borderColor = UIColor.init(hex: "2DA9EC").cgColor
            SsubscribeBtn.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        }
    }
    //prasuna added
       @IBOutlet weak var nameLabel: UILabel!
       @IBOutlet weak var profileImg: UIImageView!
       @IBOutlet weak var profileVwHight:NSLayoutConstraint!
       @IBOutlet weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

