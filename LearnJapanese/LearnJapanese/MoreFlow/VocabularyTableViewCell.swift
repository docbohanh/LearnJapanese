//
//  VocabularyTableViewCell.swift
//  LearnJapanese
//
//  Created by Nguyen Hai Dang on 11/29/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class VocabularyTableViewCell: UITableViewCell {

    @IBOutlet weak var favoriteIconImageView: UIImageView!
    @IBOutlet weak var vocabularyLabel: UILabel!
    @IBOutlet weak var readVocabulary: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func tappedReadVocabulary(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
