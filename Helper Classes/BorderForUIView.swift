//  BorderForUIView.swift
//  LTW
//  Created by Ranjeet Raushan on 03/05/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import Foundation
import UIKit

@IBDesignable
class CustomView: UIView{
    @IBInspectable var borderWidth: CGFloat = 0.0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}

