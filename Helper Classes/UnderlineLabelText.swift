//  UnderlineLabelText.swift
//  LTW
//  Created by Ranjeet Raushan on 25/09/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import Foundation
import UIKit
extension String {
   func getUnderLineAttributedText() -> NSAttributedString {
    return NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
   }
}
