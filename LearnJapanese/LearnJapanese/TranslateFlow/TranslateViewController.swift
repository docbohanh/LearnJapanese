//
//  TranslateViewController.swift
//  LearnJapanese
//
//  Created by Nguyen Hai Dang on 11/29/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {

    @IBOutlet weak var inputTextView: KMPlaceholderTextView!
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        inputTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func hideKeyboard() {
        view.endEditing(true)
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
        let parameter:  [String : String] = ["q":inputTextView.text,"key":API_KEY_TRANSLATE_GOOGLE,"source":source,"target":target]
        
        APIManager.sharedInstance.getDataToURL(url: "https://translation.googleapis.com/language/translate/v2", parameters:parameter , onCompletion: {response in
            print(response)
            LoadingOverlay.shared.hideOverlayView()
//            self.outputTextView.isHidden = false
//            self.translateButton.isHidden = true
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
