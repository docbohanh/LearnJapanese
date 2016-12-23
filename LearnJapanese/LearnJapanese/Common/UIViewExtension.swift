//
//  UIViewExtension.swift
//  MoneySaver
//
//  Created by Hai Dang Nguyen on 12/20/16.
//  Copyright © 2016 McLab. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    // MARK: Color
    func color(withRGBA RGBA: UInt) -> UIColor {
        return UIColor(red: CGFloat((RGBA & 0xFF000000) >> 24) / 255.0,
                       green: CGFloat((RGBA & 0x00FF0000) >> 16) / 255.0,
                       blue: CGFloat((RGBA & 0x0000FF00) >> 8) / 255.0,
                       alpha: CGFloat(RGBA & 0x000000FF) / 255.0)
    }
    
    func color(withRGB RGB: UInt, andAlpha alpha: Int) -> UIColor {
        return UIColor(red: CGFloat((RGB & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((RGB & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(RGB & 0x0000FF) / 255.0,
                       alpha: 1)
    }
    
    func setThemeColor(index:Int) {
        self.backgroundColor = self.color(withRGB: UInt(THEME_COLOR_MAIN[index]), andAlpha: 100)
    }
    
    func setupSegmentDefaultColor() {
        self.backgroundColor = self.color(withRGB: 0x27ae60, andAlpha: 38)
    }
    
    func setupTabBarDefaultColor() {
        self.backgroundColor = self.color(withRGB: 0x34495e, andAlpha: 100)
    }
    
    func setupTabBarSelectedDefaultColor() {
        self.backgroundColor = self.color(withRGB: 0x2c3e50, andAlpha: 100)
    }
    
    func setupBackgroundTableViewColor() {
        self.backgroundColor = self.color(withRGB: 0xecf0f1, andAlpha: 100)
    }
    
    func setupBackgroundGrayDefaultColor() {
        self.backgroundColor = self.color(withRGB: 0x000000, andAlpha: 12)
    }
}
extension UINavigationBar {
    func setThemeBarTinColor(index:Int) {
        self.barTintColor = self.color(withRGB: UInt(THEME_COLOR_MAIN[index]), andAlpha: 100)
    }
}
