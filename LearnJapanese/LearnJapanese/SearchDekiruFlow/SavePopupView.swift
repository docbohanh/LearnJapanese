//
//  SavePopupView.swift
//  LearnJapanese
//
//  Created by Thuy Phan on 11/29/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

typealias CompletionBlock = () -> Void

class SavePopupView: UIView {

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var myFlashCardsLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    
    @IBOutlet weak var meaningTextView: KMPlaceholderTextView!
    @IBOutlet weak var saveButton: UIButton!
    
    var saveBlock : CompletionBlock?
    
    override func awakeFromNib() {
        Common.boundView(button: meaningTextView, cornerRadius: 3.0, color: UIColor.lightGray, borderWith: 1.0)
        Common.boundView(button: saveButton, cornerRadius: 3.0, color: UIColor.white, borderWith: 1.0)
        meaningTextView.placeholder = "Hãy ghi lại ý nghĩa chính của từ ..."
        Common.boundView(button: meaningTextView, cornerRadius: 3.0, color: UIColor.clear, borderWith: 0)
    }
    
    func setup(saveBlk:@escaping CompletionBlock) -> Void {
        saveBlock = saveBlk
    }
    
    @IBAction func saveButton_clicked(_ sender: Any) {
        self.saveBlock?()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
