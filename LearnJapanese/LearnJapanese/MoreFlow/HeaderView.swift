//
//  HeaderView.swift
//  LearnJapanese
//
//  Created by Nguyen Hai Dang on 11/29/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
protocol ShowVocaburaryListDelegate {
    func tappedShowVocaburaryList(sender: HeaderView,flashCard:String)
    func tappedPlaySoundList(sender: UIButton)
}
class HeaderView: UIView {
    var delegate: ShowVocaburaryListDelegate?
    
    @IBOutlet weak var backgroundHeaderButton: UIButton!
    @IBOutlet weak var iconHeaderImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var flashCard = ""
    
    @IBOutlet weak var playSoundButton: UIButton!
     @IBAction func tappedShowVocabulary(_ sender: Any) {
        delegate?.tappedShowVocaburaryList(sender: self,flashCard: flashCard)
     }
 

    @IBAction func tappedPlaySound(_ sender: UIButton) {
        delegate?.tappedPlaySoundList(sender: sender)
    }
}
