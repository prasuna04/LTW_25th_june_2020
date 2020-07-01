//  CloseButton.swift
//  LTW
//  Created by Ranjeet Raushan on 14/04/19.
//  Copyright © 2019 Vaayoo. All rights reserved.

import UIKit

internal class CloseButton: UIButton {

    var iconSize: CGFloat = 8 // not for iPhone SE , just ignore SE as per Designer(Sujith Johns & Manju )
    var lineWidth: CGFloat = 2 // not for iPhone SE , just ignore SE as per Designer(Sujith Johns & Manju )
    var lineColor: UIColor = UIColor.white.withAlphaComponent(0.54)

    weak var tagView: TagView?

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()

        path.lineWidth = lineWidth
        path.lineCapStyle = .round

        let iconFrame = CGRect(
            x: (rect.width - iconSize) / 2.0,
            y: (rect.height - iconSize) / 2.0,
            width: iconSize,
            height: iconSize
        )

        path.move(to: iconFrame.origin)
        path.addLine(to: CGPoint(x: iconFrame.maxX, y: iconFrame.maxY))
        path.move(to: CGPoint(x: iconFrame.maxX, y: iconFrame.minY))
        path.addLine(to: CGPoint(x: iconFrame.minX, y: iconFrame.maxY))

        lineColor.setStroke()

        path.stroke()
    }
}
