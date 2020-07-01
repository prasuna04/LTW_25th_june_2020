//  NoListItem.swift
//  LTW
//  Created by Ranjeet Raushan on 06/06/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

class NoListItem: UIView {
  @IBOutlet weak var contntView: UIView!
    
    override init(frame: CGRect) {//for using custom view  in code
        super.init(frame: frame)
        commonint()
    }
    required init?(coder aDecoder: NSCoder) {//for using custom view  in IB
        super.init(coder: aDecoder)
        commonint()
    }
    private func commonint() {
    }
}
