//  UnderlineButtonText.swift
//  LTW
//  Created by Ranjeet Raushan on 11/04/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit
import Foundation

extension UIButton {
    func underlineButtonText() {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
