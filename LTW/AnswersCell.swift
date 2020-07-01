//  AnswersCell.swift
//  Task1
//  Created by vaayoo on 17/11/19.
//  Copyright © 2019 Vaayoo. All rights reserved.

import UIKit

class AnswersCell: UITableViewCell {

    @IBOutlet weak var marksLbl: UILabel!//yasodha
    @IBOutlet weak var yourAnswer: UILabel!
    @IBOutlet weak var AnsewStatusLBL: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var AskedQuestionLBL: UILabel!
    @IBOutlet weak var questionLBL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
  //  func updateLable(_ a: Int,_ htmlText : String,_ yourAnswer: String)
     func updateLable(_ a: Int,_ htmlText : String,_ yourAnswer: String,_ questionMarks: String!)//Added by yasodha
     {
         
        //taking the particular index value and assigning it to the label with adding one number
        
        questionLBL.text = "Question \(a+1)"
         marksLbl.text = questionMarks!// Added by yasodha 20/3/2020
//       AskedQuestionLBL.text = htmlText
        if htmlText.count > 0 {
        AskedQuestionLBL.attributedText = htmlText.html2Attributed
        }
        //checking weather the answer is there are not if it is there then assigning it to the lable
        if yourAnswer.count > 0 {
            AnsewStatusLBL.text = "Answer"
            AnsewStatusLBL.textColor = UIColor.black
            /* Updated By Ranjeet on 9th April 2020 - starts here */
            if #available(iOS 13.0, *) {
                AnsewStatusLBL.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            /* Updated By Ranjeet on 9th April 2020 - ends here */
            self.yourAnswer.attributedText = yourAnswer.html2Attributed
        }               // OR else showing a lable as no answer and making answer label as null 
        else {
            AnsewStatusLBL.text = "NO Answer"
//            AnsewStatusLBL.textColor = UIColor.red /* Commented By Ranjeet on 9th April 2020 */
              AnsewStatusLBL.textColor = UIColor.black /* Updated By Ranjeet on 9th April 2020 */
             
            /* Updated  By Ranjeet on 9th April 2020 - starts  here  */
            if #available(iOS 13.0, *) {
                AnsewStatusLBL.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
            }
            /* Updated  By Ranjeet on 9th April 2020 - ends here  */
            self.yourAnswer.text = ""
        }
        
        
        //--------------------------below is to make uiview curved and have shadow -----------------------
        cellView.layer.cornerRadius = 5.0
        cellView.layer.shadowColor = UIColor.gray.cgColor
        cellView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cellView.layer.shadowRadius = 5.0
        cellView.layer.shadowOpacity = 0.7
    }
}
