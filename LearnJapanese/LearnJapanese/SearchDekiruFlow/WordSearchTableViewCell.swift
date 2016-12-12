//
//  WordSearchTableViewCell.swift
//  LearnJapanese
//
//  Created by Thuy Phan on 11/29/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class WordSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var wordTrailingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func deleteButton_clicked(_ sender: Any) {
    }
    
    func initCell(wordModel: WordModel) -> Void {
        self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        deleteButton.isHidden = true
        wordTrailingConstraint.constant = 10
        iconImageView.image = UIImage.init(named: "icon_search")
    }
    func initHistoryCell(wordModel: WordModel) -> Void {
        self.accessoryType = UITableViewCellAccessoryType.none
        deleteButton.isHidden = false
        wordTrailingConstraint.constant = 60
        iconImageView.image = UIImage.init(named: "icon_history")
    }
    
}
