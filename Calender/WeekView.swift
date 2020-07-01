//
//  WeekView.swift
//  task7
//
//  Created by vaayoo on 18/01/20.
//  Copyright © 2020 Vaayoo. All rights reserved.
//

import UIKit

   /*  Updated By Ranjeet on 27th March 2020  */
@IBDesignable
 public class WeekView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable var cornerRadius : CGFloat = 4 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    /*  Updated By Ranjeet on 27th March 2020 - starts here */
    @IBInspectable var shadowColor : UIColor = .darkGray {
        didSet{
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
      /*  Updated By Ranjeet on 27th March 2020 - ends here */
    @IBInspectable var shadowRadius : CGFloat = 2 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }
    @IBInspectable var shadowOpacity : Float = 1 {
        didSet{
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    public override  func awakeFromNib() {
          self.backgroundColor=UIColor.clear
          setupViews()
    }
    func setupViews() {
           addSubview(myStackView)
           myStackView.topAnchor.constraint(equalTo: topAnchor).isActive=true
           myStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
           myStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
           myStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
           
           let daysArr = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
           for i in 0..<7 {
               let lbl=UILabel()
               lbl.text=daysArr[i]
               lbl.textAlignment = .center
               lbl.textColor = .systemBlue
            lbl.backgroundColor = UIColor.init(named: "background_Color")
               myStackView.addArrangedSubview(lbl)
           }
       }
       
       let myStackView: UIStackView = {
           let stackView=UIStackView()
           stackView.distribution = .fillEqually
           stackView.translatesAutoresizingMaskIntoConstraints=false
           return stackView
       }()
}
