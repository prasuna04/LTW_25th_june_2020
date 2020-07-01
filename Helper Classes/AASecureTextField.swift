//  AASecureTextField.swift
//  LTW
//  Created by Ranjeet Raushan on 30/04/19.
//  Copyright © 2019 vaayoo. All rights reserved.


import UIKit
@IBDesignable class AASecureTextField: UITextField {
    
    @IBInspectable var showImage: UIImage = UIImage(){
        didSet {
            self.showTextImage = showImage
        }
    }
    @IBInspectable var hideImage: UIImage = UIImage(){
        didSet {
            self.hideTextImage = hideImage
        }
    }
    var showTextImage : UIImage!
    var hideTextImage : UIImage!
    var eyeButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.addShowHideButton()
        
    }
    
    
    @objc fileprivate func toggleShowPassword(_ sender:AnyObject){
        
        let wasFirstResponder = false
        
        if wasFirstResponder == self.isFirstResponder {
            
            self.resignFirstResponder()
            
        }
        
        self.isSecureTextEntry = !self.isSecureTextEntry
        
        self.changeImageWithAnimation()
        
        
    }
    
    
    fileprivate func addShowHideButton(){
        
        let height = self.frame.size.height;
        let frame = CGRect(x: 0,y: 0, width: 50, height: height)
        
        eyeButton = UIButton(frame: frame)
        eyeButton.backgroundColor = .clear
        eyeButton.setImage(showTextImage, for: UIControl.State())
        self.rightViewMode = UITextField.ViewMode.whileEditing
        eyeButton.addTarget(self, action: #selector(toggleShowPassword(_:)), for: UIControl.Event.touchUpInside)
        self.rightView = eyeButton
        self.addSubview(eyeButton)
        
    }
    
    
    override func becomeFirstResponder() -> Bool {
        
        let returnValue = super.becomeFirstResponder()
        
        if (returnValue) {
            
            self.changeImageWithAnimation()
            
        }
        
        return returnValue;
        
    }
    
    fileprivate func changeImageWithAnimation(){
        
        
        eyeButton.alpha = 0
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [], animations: {
            
            self.eyeButton.alpha = 1
            
            if self.isSecureTextEntry {
                self.eyeButton.setImage(self.showTextImage, for: UIControl.State())
            }else {
                self.eyeButton.setImage(self.hideTextImage, for: UIControl.State())
                self.resetTextFont()
            }
            
        }, completion: nil)
        
    }
    
    
    fileprivate func resetTextFont(){
        
        self.attributedText = NSAttributedString(string: self.text!)
        
    }
    
}

/*
 Future Reference -
 https://github.com/AaoIi/AASecureTextField
 */
