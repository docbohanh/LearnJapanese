//
//  SavePopupView.swift
//  LearnJapanese
//
//  Created by Thuy Phan on 11/29/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class SavePopupView: UIView {

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var myFlashCardsLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var meaningTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        Common.boundView(button: meaningTextView, cornerRadius: 3.0, color: UIColor.lightGray, borderWith: 1.0)
        Common.boundView(button: saveButton, cornerRadius: 3.0, color: UIColor.white, borderWith: 1.0)
    }
    
    @IBAction func saveButton_clicked(_ sender: Any) {
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
