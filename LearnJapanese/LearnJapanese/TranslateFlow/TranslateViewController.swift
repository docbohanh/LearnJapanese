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
    @IBOutlet weak var outputTextView: UIView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var chooseDictionaryButton: UIButton!
    @IBOutlet weak var backToFirstButton: UIButton!
    @IBOutlet weak var iconAppImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProjectCommon.boundViewWithCornerRadius(button: translateButton,cornerRadius: 4.0)
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
        outputTextView.isHidden = true
        translateButton.isHidden = false
    }
    
    @IBAction func tappedTranslate(_ sender: Any) {
        outputTextView.isHidden = false
        translateButton.isHidden = true
        var source:String = "ja"
        var target:String = "vi"
        
        
        if chooseDictionaryButton.isSelected {
            source = "vi"
            target = "ja"
        } else {
            source = "ja"
            target = "vi"
        }
        LoadingOverlay.shared.showOverlay(view: self.view)
        let parameter:  [String : String] = ["q":inputTextView.text,"key":"AIzaSyBWIcG95Sr_hwE2_cgRW_N91FnXCqE6soM","source":source,"target":target,"format":"text"]
        
        APIManager.sharedInstance.getDataToURL(url: "https://www.googleapis.com/language/translate/v2", parameters:parameter , onCompletion: {response in
            print(response)
            LoadingOverlay.shared.hideOverlayView()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchWithTex(text:String) -> Void {
        let textToTranslate = text
        let parameters = ["key":API_KEY_TRANSLATE_GOOGLE,"q":"\(textToTranslate)",
            "source":"vi","target":"ja"]
        APIManager.sharedInstance.getDataToURL(url: "https://www.googleapis.com/language/translate/v2/languages", parameters: parameters, onCompletion: {(response) in
            print(response)
        
        })
    }

}
