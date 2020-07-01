//  Segment.swift
//  LTW
//  Created by Ranjeet Raushan on 13/05/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class Segment: UISegmentedControl {
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
        if let aSize = UIFont(name: "System", size: 12.0) {
            setTitleTextAttributes([NSAttributedString.Key.font: aSize, NSAttributedString.Key.foregroundColor: UIColor.init(hex: "2DA9EC")], for: .normal)
        }
        if let aSize = UIFont(name: "System", size: 12.0) {
            setTitleTextAttributes([NSAttributedString.Key.font: aSize, NSAttributedString.Key.foregroundColor: UIColor.init(hex: "2DA9EC")], for: .selected)
        }
        setWidthTosegmetControl(view: self)
    }
    func setWidthTosegmetControl(view :UIView)  {
        let subviews = view.subviews
        for subview in subviews {
            if subview is UILabel {
                let label: UILabel? = (subview as? UILabel)
                label?.adjustsFontSizeToFitWidth = true
                label?.numberOfLines = 0
            }else {
                setWidthTosegmetControl(view: subview)
            }
        }
    }
}
