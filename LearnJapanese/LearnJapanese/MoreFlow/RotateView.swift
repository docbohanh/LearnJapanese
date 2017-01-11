//
//  RotateView.swift
//  LearnJapanese
//
//  Created by Thuy Phan on 1/6/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit

protocol RotateViewDelegate {
    func flashCardTapped(sender:UIButton,index:Int) -> Void
    func favoriteTapped(sender:UIButton,index:Int) -> Void
    func playSoundTapped(sender:UIButton,index:Int) -> Void
    func rotateScreen(index:Int) -> Void
}

class RotateView: UIView {
    
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var wordButton: UIButton!
    @IBOutlet weak var flashCardButton: UIButton!
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var wordImageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var translateTextLabel: UILabel!
    var index : Int!
    var delegate : RotateViewDelegate!
    var isShowImage = false
    

    @IBAction func tappedRotateView(_ sender: UIButton) {
        self.delegate.rotateScreen(index: index)
    }
    
    @IBAction func flashCardButton_clicked(_ sender: Any) {
        self.delegate.flashCardTapped(sender: sender as! UIButton, index: index)
    }
    @IBAction func favoriteButton_clicked(_ sender: Any) {
        self.delegate.favoriteTapped(sender: sender as! UIButton, index: index)
    }
    @IBAction func playSoundButton_clicked(_ sender: Any) {
        self.delegate.playSoundTapped(sender: sender as! UIButton, index: index)
    }

}
