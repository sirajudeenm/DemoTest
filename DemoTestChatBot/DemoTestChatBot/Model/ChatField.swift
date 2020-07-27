//
//  ChatField.swift
//  DemoTestChatBot
//
//  Created by Apple on 25/07/20.
//  Copyright © 2020 ixm. All rights reserved.
//

import UIKit

extension UITextField {
   
    func underlinedRegStatic(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(red: 131/255, green: 129/255, blue:129/255, alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
