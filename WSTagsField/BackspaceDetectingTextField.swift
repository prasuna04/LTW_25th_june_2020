//  BackspaceDetectingTextField.swift
//  LTW
//  Created by Ranjeet Raushan on 22/07/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import UIKit

protocol BackspaceDetectingTextFieldDelegate: UITextFieldDelegate {
    // Notify whenever the backspace key is pressed
    func textFieldDidDeleteBackwards(_ textField: UITextField)
}
class BackspaceDetectingTextField: UITextField {

    var onDeleteBackwards: (() -> Void)?

    init() {
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func deleteBackward() {
        onDeleteBackwards?()
        // Call super afterwards. The `text` property will return text prior to the delete.
        super.deleteBackward()
    }
}
