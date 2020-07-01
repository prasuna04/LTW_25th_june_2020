//  ObjectiveQues.swift
//  LTW
//  Created by manjunath Hindupur on 11/07/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class ObjectiveQues: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var questionTV: UITextView!
    @IBOutlet weak var objQues1TF: UITextField!
    @IBOutlet weak var objQues2TF: UITextField!
    @IBOutlet weak var objQues3TF: UITextField!
    @IBOutlet weak var objQues4TF: UITextField!
    @IBOutlet weak var hrBtn: UIButton!
    @IBOutlet weak var hrDownArrBtn: UIButton!
    @IBOutlet weak var minBtn: UIButton!
    @IBOutlet weak var minDownArrBtn: UIButton!
    @IBOutlet weak var writeAnswerBtn: UIButton!
    @IBOutlet weak var answerDropDownBtn: UIButton!
    @IBOutlet weak var answerDownArrBtn: UIButton!
    @IBOutlet weak var ansDropdownContainer: UIView!
    @IBOutlet weak var marksTextField: UITextField!//yasodha
    
       override init(frame: CGRect) {
        super.init(frame: frame)
        //commitInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       // commitInit()
        //fatalError("init(coder:) has not been implemented")
        
    }
    private func commitInit() {
        Bundle.main.loadNibNamed("ObjectiveQues", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
    

    @IBAction func onHrBtnClick(_ sender: UIButton) {
    }
    
    @IBAction func onMinBtnClick(_ sender: UIButton) {
    }
    
    @IBAction func onAnsBtnClick(_ sender: UIButton) {
    }
}
