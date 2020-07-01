//  TextQues.swift
//  LTW
//  Created by manjunath Hindupur on 11/07/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class TextQues: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var questionTV: UITextView!
    @IBOutlet weak var hrBtn: UIButton!
    @IBOutlet weak var hrDownArrBtn: UIButton!
    
    @IBOutlet weak var minBtn: UIButton!
    
    @IBOutlet weak var minDownArrBtn: UIButton!
    @IBOutlet weak var writeAnswerBtn: UIButton!
    @IBOutlet weak var answerTV: UITextView!
    @IBOutlet weak var answerContainerView: CardView!
  /* Added By Ranjeet */
        {
        didSet{
            if #available(iOS 13.0, *) {
                answerContainerView.shadowColor = UIColor.label 
                answerContainerView.backgroundColor = UIColor.systemBackground
            } else {
                // Fallback on earlier versions
            }
        }
    }
    @IBOutlet weak var marksTextField: UITextField!//yasodha
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    private func commitInit() {
        Bundle.main.loadNibNamed("TextQues", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
    
    @IBAction func onHrBtnClick(_ sender: UIButton) {
    }
    
    @IBAction func onMinBtnClick(_ sender: UIButton) {
    }
}
