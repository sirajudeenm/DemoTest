//
//  CardView.swift
//  DemoTestChatBot
//
//  Created by Apple on 25/07/20.
//  Copyright © 2020 ixm. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 5
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.yellow
    @IBInspectable var shadowOpacity: Float = 0.9

    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        layer.shadowRadius = 5.0
    }

}

//
//layer.cornerRadius = 10.0
//       layer.shadowColor = UIColor.darkGray.cgColor
//       layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
//       layer.shadowRadius = 25.0
//       layer.shadowOpacity = 0.9
