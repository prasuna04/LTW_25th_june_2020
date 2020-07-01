//  Extentions.swift
//  LTW
//  Created by Ranjeet Raushan on 08/04/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import Foundation
import UIKit
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension UITextField {
    
    func useUnderline() {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.init(hex: "2DA9EC").cgColor
        border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width + 800, height: self.frame.size.height))
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
    
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    func setPlaceHolderColor(color: String){
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(hex: color)])
    }
        func addDoneButtonToKeyboard(myActionDone:Selector?,myActionCancel:Selector?){
            
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
            doneToolbar.barStyle = UIBarStyle.default
            
            let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: myActionCancel)
    //        cancel.tintColor = VSCore().blueColor()
            
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: myActionDone)
    //        done.tintColor = VSCore().blueColor()
                
            doneToolbar.items = [cancel,flexSpace,done]
            doneToolbar.sizeToFit()
            
            self.inputAccessoryView = doneToolbar

            
            
        }
    
}
extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

extension UISegmentedControl {
    
    func makeTitleMultiline(){
        for i in 0...self.numberOfSegments - 1 {
            let label = UILabel(frame: CGRect(x: 0, y: -7, width: (self.frame.width-10)/CGFloat(self.numberOfSegments), height: self.frame.height))
            label.textColor = i == 0 ? UIColor.red : UIColor.blue
            label.text = self.titleForSegment(at: i)
            label.numberOfLines = 0
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.tag = i
            self.setTitle("", forSegmentAt: i)
            self.subviews[i].addSubview(label)
        }
    }
    
    func setSelectedTitleColor() {
        for i in 0...self.numberOfSegments - 1 {
            let label = self.subviews[self.numberOfSegments - 1 - i].subviews[1] as? UILabel
            label?.textColor = label?.tag == self.selectedSegmentIndex ? UIColor.red : UIColor.blue
            label?.numberOfLines = 2
        }
    }
    
}

extension UIImageView {
    //Functin
    //MARK:- Corner Radius of only two side of UIViews
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    func roundCorner(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
   // add by chandra for animation for the button
    enum GlowEffect: Float {
        case small = 0.4, normal = 2, big = 15
    }

    func doGlowAnimation(withColor color: UIColor, withEffect effect: GlowEffect = .normal) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowRadius = 0
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero

        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = 0
        glowAnimation.toValue = effect.rawValue
        glowAnimation.beginTime = CACurrentMediaTime()+0.3
        glowAnimation.duration = CFTimeInterval(0.3)
        glowAnimation.fillMode = .removed
        glowAnimation.autoreverses = true
        glowAnimation.repeatCount = 5
        glowAnimation.isRemovedOnCompletion = true
        layer.add(glowAnimation, forKey: "shadowGlowingAnimation")
    }
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}
public extension Sequence where Iterator.Element: CustomStringConvertible {
    func joined(seperator: String) -> String {
        return self.map({ (val) -> String in
            "\(val)"
        }).joined(separator: seperator)
    }
}

extension UserDefaults {
    func contains(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
/* Added by yasodha on 24/1/2020 - starts here */
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
/* Added by yasodha on 24/1/2020 - ends here */

extension UILabel {
func useUnderline() {
    let border = CALayer()
    let borderWidth = CGFloat(1.0)
    border.borderColor = UIColor.init(hex: "2DA9EC").cgColor
    border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width + 800, height: self.frame.size.height))
    border.borderWidth = borderWidth
    self.layer.addSublayer(border)
    self.layer.masksToBounds = true
    
}
    
    
}
extension UIButton{
    func boderForBtn(color:UIColor) {
        self.backgroundColor = .clear
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = self.frame.height / 12
    }
//    add by chandra for button animation start here to
    func flash(color:UIColor) {
//
//        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
//        pulseAnimation.duration = 0.5
//        pulseAnimation.fromValue = 0
//        pulseAnimation.toValue = 1
//        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        pulseAnimation.autoreverses = true
//        pulseAnimation.repeatCount = 5
//        layer.add(pulseAnimation, forKey: "animateOpacity")
        
        
//
    let flash = CABasicAnimation(keyPath: "opacity")
    flash.duration = 0.3
    flash.fromValue = 1
    flash.toValue = 0.1
    flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    flash.autoreverses = true
    self.backgroundColor = color
    flash.repeatCount = 5
    layer.add(flash, forKey: nil)
    }
    func  fullflash(btn:UIButton){
        let scaleAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 0.3
        scaleAnimation.repeatCount = 30.0
        scaleAnimation.autoreverses = true
        scaleAnimation.fromValue = 1.2
        scaleAnimation.toValue = 0.8
        self.backgroundColor =  UIColor.init(hex: "2DA9EC")
        self.layer.add(scaleAnimation, forKey: "scale")
    }
    
    func springAnimation(btn:UIButton){
        btn.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
           UIView.animate(withDuration: 2.0,
                          delay: 0,
                          usingSpringWithDamping: 0.2,
                          initialSpringVelocity: 6.0,
                          options: .allowUserInteraction,
                          animations: { [weak self] in
                           btn.transform = .identity
               },
                          completion: nil)
    }
    
    func borderAnimation(btn:UIButton,color:UIColor,keyPath:String){
//        key paths for animation
//        fillColor
//        lineDashPhase
//        lineWidth
//        miterLimit
//        strokeColor
//        strokeStart
//        strokeEnd
        let storkeLayer = CAShapeLayer()
        storkeLayer.fillColor = UIColor.clear.cgColor
        storkeLayer.strokeColor = color.cgColor
        storkeLayer.lineWidth = 2
        storkeLayer.path = CGPath.init(roundedRect: btn.bounds, cornerWidth: 5, cornerHeight: 5, transform: nil) // sa
        btn.layer.addSublayer(storkeLayer)
        let animation = CABasicAnimation(keyPath:keyPath)
        animation.fromValue = CGFloat(0.0)
        animation.toValue = CGFloat(1.0)
        animation.duration = 1.5
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        storkeLayer.add(animation, forKey: "circleAnimation")
    }
    
    
    
    
    
//   add by chandra for button animation ends here to
}
extension UITextView
{
    func useUnderline() {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.init(hex: "2DA9EC").cgColor
        border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width + 800, height: self.frame.size.height))
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
}

/*  Added By Ranjeet on 31st MArch 2020 - starts here */
extension NSLocale {
    class func locales1(countryName1 : String) -> String {
        let locales : String = ""
        for localeCode in NSLocale.isoCountryCodes {
            let countryName = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: localeCode)
            if countryName1.lowercased() == countryName?.lowercased() {
                return localeCode
            }
        }
        return locales
    }
}
/*  Added By Ranjeet on 31st MArch 2020 - ends here */
/*Added by yasodha on 24/4/2020 starts here */
extension Double {
    var isInt: Bool {
        let intValue = Int(self)
        return  Double(intValue) == self
    }
}
/*Added by yasodha on 24/4/2020 ends here */
