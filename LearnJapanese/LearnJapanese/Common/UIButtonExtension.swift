//
//  UIButtonExtension.swift
//  MoneySaver
//
//  Created by Hai Dang Nguyen on 12/20/16.
//  Copyright © 2016 McLab. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func setupTitleWhiteColor() {
        self.setTitleColor(self.color(withRGB: 0xFFFFFF, andAlpha: 100), for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    func setupDisableTitleColor() {
        self.setTitleColor(self.color(withRGB: 0x84CE8F, andAlpha: 100), for: .normal)
    }
}
