//
//  Common.swift
//  LearnJapanese
//
//  Created by Nguyen Hai Dang on 12/9/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class Common: NSObject {
    static func boundView(button:UIView) -> Void {
        button.clipsToBounds = true
        button.layer.cornerRadius = button.frame.size.height/2;
        button.layer.borderWidth = 1.0
        button.layer.borderColor = COMMON_COLOR.cgColor
    }
    
    static func boundViewWithColor(button:UIView, color: UIColor) {
        button.clipsToBounds = true
        button.layer.cornerRadius = button.frame.size.height/2;
        button.layer.borderWidth = 1.0
        button.layer.borderColor = color.cgColor
    }
    
    static func boundViewWithCornerRadius(button: UIView,cornerRadius: CGFloat) -> Void {
        button.clipsToBounds = true
        button.layer.cornerRadius = cornerRadius;
        button.layer.borderWidth = 1.0
        button.layer.borderColor = COMMON_COLOR.cgColor
    }
}
