//
//  MonthViews.swift
//  task7
//
//  Created by vaayoo on 18/01/20.
//  Copyright © 2020 Vaayoo. All rights reserved.
//

import UIKit

protocol MonthViewDelegate: class {
    func didChangeMonth(monthIndex: Int, year: Int)
}


public class MonthViews: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable var textFont : UIFont = UIFont.boldSystemFont(ofSize: 12) {
        didSet {
            self.lblName.font = textFont//UIFont.boldSystemFont(ofSize: textSize)
        }
    }
    
    public  override func awakeFromNib() {
        //self.init()
        //self.backgroundColor = UIColor.init(hex: "2DA9EC")
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        setupViews()
        btnLeft.isEnabled=false
    }

    var monthsArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var currentMonthIndex = 0
    var currentYear: Int = 0
    var delegate: MonthViewDelegate?
    
    @objc func btnLeftRightAction(sender: UIButton) {
           if sender == btnRight {
               currentMonthIndex += 1
               if currentMonthIndex > 11 {
                   currentMonthIndex = 0
                   currentYear += 1
               }
           } else {
               currentMonthIndex -= 1
               if currentMonthIndex < 0 {
                   currentMonthIndex = 11
                   currentYear -= 1
               }
           }
           lblName.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
           delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
       }
    func setupViews() {
        self.addSubview(lblName)
        lblName.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lblName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive=true
        lblName.widthAnchor.constraint(equalToConstant: 150).isActive=true
        lblName.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
        lblName.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
        
        self.addSubview(btnRight)
        btnRight.topAnchor.constraint(equalTo: topAnchor).isActive=true
        //btnRight.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        btnRight.leadingAnchor.constraint(equalTo: lblName.trailingAnchor).isActive=true
        btnRight.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnRight.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
        
        self.addSubview(btnLeft)
        btnLeft.topAnchor.constraint(equalTo: topAnchor).isActive=true
       // btnLeft.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        btnLeft.trailingAnchor.constraint(equalTo: lblName.leadingAnchor).isActive=true
        btnLeft.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnLeft.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
    }
    
    let lblName: UILabel = {
           let lbl=UILabel()
           lbl.text="Default Month Year text"
           lbl.textColor = UIColor.white
           lbl.textAlignment = .center
           lbl.font=UIFont.boldSystemFont(ofSize: 16)
           lbl.translatesAutoresizingMaskIntoConstraints=false
           return lbl
       }()
     let btnRight: UIButton = {
           let btn=UIButton()
           btn.setTitle(">", for: .normal)
           btn.setTitleColor(UIColor.white, for: .normal)
           btn.translatesAutoresizingMaskIntoConstraints=false
           btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
           return btn
       }()
  let btnLeft: UIButton = {
        let btn=UIButton()
        btn.setTitle("<", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
       // btn.tintColor = UIColor.white
        btn.setTitleColor(UIColor.lightGray, for: .disabled)
        return btn
    }()
}
