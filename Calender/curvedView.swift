//
//  curvedView.swift
//  task7
//
//  Created by vaayoo on 19/01/20.
//  Copyright © 2020 Vaayoo. All rights reserved.
//

import UIKit

public class curvedView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  
    public override func awakeFromNib() {
               self.layer.cornerRadius = 3
        self.layer.shadowOffset = CGSize.zero
//               self.layer.borderColor = UIColor.white.cgColor
//               self.layer.borderWidth = 1.0
               self.layer.shadowColor = UIColor.darkGray.cgColor
               self.layer.shadowRadius = 4.0
               self.layer.shadowOpacity = 1.0
    }
}
