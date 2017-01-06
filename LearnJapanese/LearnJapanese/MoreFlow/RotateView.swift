//
//  RotateView.swift
//  LearnJapanese
//
//  Created by Thuy Phan on 1/6/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit

protocol RotateViewDelegate {
    func flashCardTapped(index:Int) -> Void
    func favoriteTapped(index:Int) -> Void
    func playSoundTapped(index:Int) -> Void
}

class RotateView: UIView {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var translateTextLabel: UILabel!
    var index : Int!
    var delegate : RotateViewDelegate!
    var isShowImage = false
    

    @IBAction func flashCardButton_clicked(_ sender: Any) {
        self.delegate.flashCardTapped(index: index)
    }
    @IBAction func favoriteButton_clicked(_ sender: Any) {
        self.delegate.favoriteTapped(index: index)
    }
    @IBAction func playSoundButton_clicked(_ sender: Any) {
        self.delegate.playSoundTapped(index: index)
    }

}
