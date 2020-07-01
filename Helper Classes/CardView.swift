//  CardView.swift
//  LTW
//  Created by Ranjeet Raushan on 08/04/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import Foundation
import UIKit
import AVKit



class LandscapeAVPlayerController: AVPlayerViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }
    
}

@IBDesignable public class CardView: UIView {
    
    @IBInspectable var cornerradius : CGFloat = 5
    @IBInspectable var shadowoffSetWidth : CGFloat = 0
    @IBInspectable var shadowoffSetHeight : CGFloat = 0 
    @IBInspectable var shadowColor : UIColor = UIColor.darkGray
    @IBInspectable var shadowOpacity : CGFloat = 0.5
    @IBInspectable var shadowRadius : CGFloat = 8
    
    override public func layoutSubviews() {
        layer.shadowColor = shadowColor.cgColor
        layer.cornerRadius = cornerradius
        layer.shadowOffset = CGSize(width: shadowoffSetWidth, height: shadowoffSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerradius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
        layer.shadowRadius = shadowRadius
    }
}
