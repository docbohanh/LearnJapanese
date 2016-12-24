//
//  TranslateViewController.swift
//  LearnJapanese
//
//  Created by Nguyen Hai Dang on 11/29/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {
    
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var clearTextButton: UIButton!
    @IBOutlet weak var outputView: UIView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var chooseDictionaryButton: UIButton!
    @IBOutlet weak var backToFirstButton: UIButton!
    @IBOutlet weak var iconAppImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Common.boundViewWithCornerRadius(button: translateButton,cornerRadius: 4.0)
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        inputTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    @IBAction func tappedBack(_ sender: Any) {
    }
    
    @IBAction func tappedChooseDictionary(_ sender: UIButton) {
        if sender.isSelected {
            chooseDictionaryButton.setBackgroundImage(UIImage.init(named: "icon_change_language"), for: UIControlState.normal)
        } else {
//            chooseDictionaryButton.setBackgroundImage(UIImage.init(named: ""), for: UIControlState.normal)
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func tappedClearText(_ sender: Any) {
        outputView.isHidden = true
        translateButton.isHidden = false
    }
    
    @IBAction func tappedTranslate(_ sender: Any) {
        outputView.isHidden = false
        translateButton.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
