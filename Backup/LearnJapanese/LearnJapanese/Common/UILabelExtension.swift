//
//  UILabelExtension.swift
//  MoneySaver
//
//  Created by Hai Dang Nguyen on 12/20/16.
//  Copyright © 2016 McLab. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func setupNavigationTitleWhiteColor() {
        self.textColor = self.color(withRGB: 0xFFFFFF, andAlpha: 100)
        self.font = UIFont.boldSystemFont(ofSize: 17)
        self.textAlignment = .center
    }
    
    func setupTitleWhiteColor() {
        self.textColor = self.color(withRGB: 0xFFFFFF, andAlpha: 100)
        self.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    func setupPrimaryTextDefaultBlackColor() {
        self.textColor = self.color(withRGB: 0x000000, andAlpha: 87)
        self.font = UIFont.systemFont(ofSize: 13)
    }
    
    func setupSecondaryTextDefaultBlackColor() {
        self.textColor = self.color(withRGB: 0x000000, andAlpha: 54)
        self.font = UIFont.systemFont(ofSize: 12)
    }
    
    func setupDisableTextDefaultColor() {
        self.textColor = self.color(withRGB: 0x000000, andAlpha: 38)
    }
    
    func setupExpensedMoneyColor() {
        self.textColor = self.color(withRGB: 0xe74c3c, andAlpha: 100)
    }
    
    func setupEarningsMoneyColor() {
        self.textColor = self.color(withRGB: 0x2ecc71, andAlpha: 100)
    }
    func setupTitleHeader() {
        self.textColor = self.color(withRGB: 0x95a5a6, andAlpha: 100)
    }
}
