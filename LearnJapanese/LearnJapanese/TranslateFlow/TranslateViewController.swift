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
    @IBOutlet weak var outputTextView: UITextView!
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

    }
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func tappedBack(_ sender: Any) {
    }
    
    @IBAction func tappedChooseDictionary(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if inputTextView.text != "" {
            self.tappedTranslate(translateButton)
        }
    }
    
    @IBAction func tappedClearText(_ sender: Any) {
        inputTextView.text = ""
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
        
        APIManager.sharedInstance.postDataToURL(url: "https://translation.googleapis.com/language/translate/v2", parameters:parameter , onCompletion: {response in
            print(response)
            DispatchQueue.main.async {
                LoadingOverlay.shared.hideOverlayView()
                if (response.result.error != nil) {
//                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: (response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
//                    })
                    ProjectCommon.initAlertView(
                        viewController: self,
                        title: "Error",
                        message: (response.result.error?.localizedDescription) ?? "Unknown",
                        buttonArray: ["OK"],
                        onCompletion: { (index) in
                    })
                    
                }else {
//                    let resultDictionary = response.result.value as! [String:AnyObject]
//                    let dictResult = resultDictionary["data"] as! [String:AnyObject]
//                    let data = dictResult["translations"] as! [AnyObject]
                    
                    guard let resultDictionary = response.result.value as? [String:AnyObject],
                        let dictData = resultDictionary["data"],
                        let dictResult = dictData as? [String:AnyObject],
                        let trans = dictResult["translations"],
                        let data = trans as? [AnyObject] else {
                            
                            ProjectCommon.initAlertView(
                                viewController: self,
                                title: "Error",
                                message: "Data empty",
                                buttonArray: ["OK"],
                                onCompletion: { (index) in
                            })
                            
                            return
                    }
                    
                    if data.count > 0 {
                        let object = data[0] as! [String:AnyObject]
                        let text = object["translatedText"] as! String
                        self.outputTextView.text = text
                        self.outputTextView.isHidden = false
                        self.translateButton.isHidden = true

                    }
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
