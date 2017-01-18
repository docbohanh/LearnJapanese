//
//  WordDetailViewController.swift
//  LearnJapanese
//
//  Created by Thuy Phan on 12/9/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import AVFoundation
import MagicalRecord

class WordDetailViewController: UIViewController,saveWordDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var backgroundPopupView: UIView!
    @IBOutlet weak var searchResultScrollView: UIScrollView!
    @IBOutlet weak var searchWebView: UIWebView!
    
    @IBOutlet weak var example2Label: UILabel!
    @IBOutlet weak var meaning2Label: UILabel!
    @IBOutlet weak var wordType2Label: UILabel!
    @IBOutlet weak var examplelabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var wordType: UILabel!
    @IBOutlet weak var phienAm: UILabel!
    @IBOutlet weak var dekiruButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var wikipediaButton: UIButton!
    @IBOutlet weak var bingButton: UIButton!
    
    @IBOutlet weak var flashCardButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var googleTranslateView: UIView!
    @IBOutlet weak var sourceTranslateLabel: UILabel!
    @IBOutlet weak var targetTranslateLabel: UILabel!
    
    var searchText : String = ""
    var wordId: String = ""
    var isMyWord = Bool()
    
    var detailTranslate: Translate!
    var detailFlashCard: FlashCardDetail!
    var player: AVPlayer!
    
    
    var popupView : SavePopupView?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.text = searchText
        searchTextField.allowsEditingTextAttributes = false
        // Do any additional setup after loading the view.
        self.setupViewController()
        DispatchQueue.global().async {

        }
    }

    override func viewDidLayoutSubviews() {
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 4
        searchTextField.layer.borderColor = UIColor.white.cgColor
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.detailTranslate = (Translate.mr_findFirst(byAttribute: "id", withValue: self.wordId, in: NSManagedObjectContext.mr_default()))

        let result = FlashCardDetail.mr_find(byAttribute: "id", withValue: self.detailTranslate.id, andOrderBy: "flash_card_id", ascending: true) as? [FlashCardDetail]
        
        for object in result! {
            if let flash_card_id = object.flash_card_id {
                if flash_card_id == ".flashcard" {
                    flashCardButton.setImage(UIImage.init(named: "icon_btn_flashcash_flashcard"), for: UIControlState.normal)
                }
            }
            if let flash_card_id = object.flash_card_id {
                if flash_card_id == ".word" {
                    favoriteButton.setImage(UIImage.init(named: "icon_btn_favorite_flashcard"), for: UIControlState.normal)
                }
            }
        }
        
        self.detailFlashCard = (FlashCardDetail.mr_findFirst(byAttribute: "id", withValue: self.wordId, in: NSManagedObjectContext.mr_default()))
        if self.detailTranslate != nil {
            self.saveHistoryData(translate: self.detailTranslate)
            self.meaningLabel.text = self.detailTranslate.meaning_name
            self.examplelabel.text = self.detailTranslate.example_meaning_name
            self.titleLabel.text = self.searchText
        } else if detailFlashCard != nil {
            self.meaningLabel.text = self.detailFlashCard.meaning
            self.titleLabel.text = self.detailFlashCard.word
            self.examplelabel.text = ""
        }
        sourceTranslateLabel.text = searchText
        
        self.navigationController?.isNavigationBarHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViewController() -> Void {
        ProjectCommon.boundView(button: dekiruButton, cornerRadius: 2.0, color: UIColor.clear, borderWith: 0)
        ProjectCommon.boundView(button: googleButton, cornerRadius: 2.0, color: UIColor.clear, borderWith: 0)
        ProjectCommon.boundView(button: wikipediaButton, cornerRadius: 2.0, color: UIColor.clear, borderWith: 0)
        ProjectCommon.boundView(button: bingButton, cornerRadius: 2.0, color: UIColor.clear, borderWith: 0)
        self.createPopup()
    }
    
    func createPopup() -> Void {
        popupView = UINib(nibName: "SavePopupView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as? SavePopupView
        popupView?.clipsToBounds = true
        popupView?.layer.cornerRadius = 5.0
        popupView?.delegate = self
        popupView?.translatesAutoresizingMaskIntoConstraints = false
//        popupView.delegate = self
        backgroundPopupView.addSubview(popupView!)
        
        let views = ["popupView": popupView,
                     "backgroundPopUpView": backgroundPopupView]
        let width = view.frame.size.width - 30
        
        let dictMetric = ["widthPopup" : width]
        
        // 2
        var allConstraints = [NSLayoutConstraint]()
        
        // 3
        let verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[backgroundPopUpView]-(<=1)-[popupView(260)]",
            options: [.alignAllCenterX],
            metrics: nil,
            views: views)
        allConstraints += verticalConstraints
        // 4
        let horizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[backgroundPopUpView]-(<=1)-[popupView(widthPopup)]",
            options: [.alignAllCenterY],
            metrics: dictMetric,
            views: views)
        allConstraints += horizontalConstraints
        
        backgroundPopupView.addConstraints(allConstraints)
        backgroundPopupView.isHidden = true
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func tappedDeleteButton(_ sender: Any) {
    }
    @IBAction func tappedSoundButton(_ sender: Any) {
        if detailTranslate != nil {
            
        
        if detailTranslate.sound_url == nil || detailTranslate.sound_url?.characters.count == 0 {
            ProjectCommon.initAlertView(viewController: self, title: "", message: "Không tồn tại âm thanh này", buttonArray: ["Đóng"], onCompletion: {_ in
            })
        } else {
            let playerItem = AVPlayerItem( url:URL(string:detailTranslate.sound_url! )! )
            self.player = AVPlayer(playerItem:playerItem)
            self.player.rate = 1.0;
            self.player.play()
        }
        } else if detailFlashCard != nil {
            if detailFlashCard.source_url == nil || detailFlashCard.source_url?.characters.count == 0 {
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Không tồn tại âm thanh này", buttonArray: ["Đóng"], onCompletion: {_ in
                })
            } else {
                let playerItem = AVPlayerItem( url:URL(string:detailFlashCard.source_url! )! )
                self.player = AVPlayer(playerItem:playerItem)
                self.player.rate = 1.0;
                self.player.play()
            }
        }
    }
    @IBAction func tappedFavoriteButton(_ sender: Any) {
        let result = FlashCardDetail.mr_find(byAttribute: "id", withValue: self.detailTranslate.id, andOrderBy: "flash_card_id", ascending: true) as? [FlashCardDetail]
        let wordType = ".word"
        
        for object in result! {
            if object.flash_card_id == wordType {
                let localContext = NSManagedObjectContext.mr_default()
                object.mr_deleteEntity(in: localContext)
                localContext.mr_saveToPersistentStoreAndWait()
                favoriteButton.setImage(UIImage.init(named: "icon_btn_favorite"), for: UIControlState.normal)
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã xoá từ", buttonArray: ["Đóng"], onCompletion: {_ in
                    
                })
                return
            }
        }
        
            favoriteButton.setImage(UIImage.init(named: "icon_btn_favorite_flashcard"), for: UIControlState.normal)
        
        popupView?.wordLabel.text = searchTextField.text
        backgroundPopupView.isHidden = false
        if detailTranslate != nil {
            popupView?.meaningTextView.text = detailTranslate.meaning_name
        } else if detailFlashCard != nil{
            popupView?.meaningTextView.text = detailFlashCard.meaning

        }
        popupView?.myFlashCardsLabel.text = "Lưu từ"
        popupView?.storeType = .word
    }
    
    @IBAction func tappedSaveFlashCashButton(_ sender: Any) {
        let result = FlashCardDetail.mr_find(byAttribute: "id", withValue: self.detailTranslate.id, andOrderBy: "flash_card_id", ascending: true) as? [FlashCardDetail]
        let wordType = ".flashcard"
        
        for object in result! {
            if object.flash_card_id == wordType {
                let localContext = NSManagedObjectContext.mr_default()
                object.mr_deleteEntity(in: localContext)
                localContext.mr_saveToPersistentStoreAndWait()
                flashCardButton.setImage(UIImage.init(named: "icon_btn_flashcash"), for: UIControlState.normal)
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã xoá từ khỏi flashcard", buttonArray: ["Đóng"], onCompletion: {_ in
                
                })
                return
            }
        }
        flashCardButton.setImage(UIImage.init(named: "icon_btn_flashcash_flashcard"), for: UIControlState.normal)
        
        popupView?.wordLabel.text = searchTextField.text
        if detailTranslate != nil {
            popupView?.meaningTextView.text = detailTranslate.meaning_name
        } else if detailFlashCard != nil{
            popupView?.meaningTextView.text = detailFlashCard.meaning
            
        }
        backgroundPopupView.isHidden = false
        popupView?.myFlashCardsLabel.text = "Flash Cards của tôi"
        popupView?.storeType = .flash_card
    }
    @IBAction func tappedClosePopupButton(_ sender: Any) {
        backgroundPopupView.isHidden = true
    }
    @IBAction func tappedDekiruDictButton(_ sender: Any) {
        dekiruButton.backgroundColor = background_color
        googleButton.backgroundColor = UIColor.lightText
        wikipediaButton.backgroundColor = UIColor.lightText
        bingButton.backgroundColor = UIColor.lightText
        
        searchWebView.isHidden = true
        searchResultScrollView.isHidden = false
        googleTranslateView.isHidden = true
    }
    @IBAction func tappedGoogleButton(_ sender: Any) {
        dekiruButton.backgroundColor = UIColor.lightText
        googleButton.backgroundColor = background_color
        wikipediaButton.backgroundColor = UIColor.lightText
        bingButton.backgroundColor = UIColor.lightText
        
        searchResultScrollView.isHidden = true
        searchWebView.isHidden = true
        googleTranslateView.isHidden = false
        self.searchWithGoogle()
    }
    @IBAction func tappedWikipediaButton(_ sender: Any) {
        dekiruButton.backgroundColor = UIColor.lightText
        googleButton.backgroundColor = UIColor.lightText
        wikipediaButton.backgroundColor = background_color
        bingButton.backgroundColor = UIColor.lightText
        
        searchResultScrollView.isHidden = true
        searchWebView.isHidden = false
        googleTranslateView.isHidden = true
        let wordSearch = searchTextField.text ?? "dekiru"
        
        ///Thành Lã: 2017/01/05
        let string = "https://vi.wikipedia.org/wiki/Special:Search?search=\(wordSearch)"
        
        guard let stringURL = string.addingPercentEscapes(using: String.Encoding.utf8),
            let url = URL(string: stringURL)
            else { return }
        
        let requestObj = NSURLRequest(url: url);
        searchWebView.loadRequest(requestObj as URLRequest);
    }
    @IBAction func tappedBingButton(_ sender: Any) {
        dekiruButton.backgroundColor = UIColor.lightText
        googleButton.backgroundColor = UIColor.lightText
        wikipediaButton.backgroundColor = UIColor.lightText
        bingButton.backgroundColor = background_color
        
        searchResultScrollView.isHidden = true
        searchWebView.isHidden = false
        googleTranslateView.isHidden = true
        
    }

    func saveHistoryData(translate:Translate) {
        let word = History.mr_findFirst(byAttribute: "id", withValue: translate.id, in: NSManagedObjectContext.mr_default())
        if word == nil {
            MagicalRecord.save({localContext in
                let history = History.mr_createEntity(in: localContext)
                if let word_id = translate.id {
                    history?.id = String(describing: word_id)
                }
                
                if let Word = translate.word {
                    history?.word = Word
                }
                
                if let kana = translate.kana {
                    history?.kana = kana
                }
                
                if let Romaji = translate.romaji {
                    history?.romaji = Romaji
                }
                
                if let SoundUrl = translate.sound_url {
                    history?.sound_url = SoundUrl
                }
                
                if let LastmodifiedDate = translate.last_modified {
                    history?.last_modified = LastmodifiedDate
                }
                
                if let Modified = translate.modified {
                    history?.modified = Modified
                }
                
                if let Avatar = translate.avatar {
                    history?.avatar = Avatar
                }
                
                if let Meaning  = translate.meaning_name {
                    history?.meaning_name = Meaning
                }
                
                if let MeaningId = translate.meaningId {
                    history?.meaningId = MeaningId
                }
                
                if let Type = translate.meaning_type {
                    history?.meaning_type = Type
                }
                
                if let ExampleId = translate.example_id {
                    history?.example_id = ExampleId
                }
                
                if let Example = translate.example_name {
                    history?.example_name = Example
                }
                
                if let Meaning = translate.example_meaning_name {
                    history?.example_meaning_name = Meaning
                }
                
                if let MeaningId = translate.example_meaning_id {
                    history?.example_meaning_id = MeaningId
                }
                
                if let Romaji = translate.romaji {
                    history?.example_romaji = Romaji
                }
                
                if let Kana = translate.kana {
                    history?.example_kana = Kana
                }
                
                if let SoundUrl = translate.sound_url {
                    history?.example_sound_url = SoundUrl
                }
                
            }, completion: { contextDidSave in
                //saving is successful
                print("saving is successful")
                
            })
        }
    }
    
    func saveWordToLocal(type: MyStoreType) {
        self.backgroundPopupView.isHidden = true
        MagicalRecord.save({context in
                let wordData = FlashCardDetail.mr_createEntity(in:NSManagedObjectContext.mr_default())
                wordData?.kana = self.detailTranslate.kana ?? ""
                wordData?.word = self.detailTranslate.word ?? ""
                wordData?.source_url = self.detailTranslate.sound_url ?? ""
                wordData?.meaning = self.detailTranslate.meaning_name ?? ""
                wordData?.romaji = self.detailTranslate.romaji ?? ""
                wordData?.id = self.detailTranslate.id ?? ""
                wordData?.avatar = self.detailTranslate.avatar ?? ""
                if type == .flash_card {
                    wordData?.flash_card_id = ".flashcard"
                } else {
                    wordData?.flash_card_id = ".word"
                    
                }
            }, completion: {didContext in
                if let oldFlashCard = FlashCard.mr_find(byAttribute: "id", withValue: type == .word ? ".word" : ".flashcard") {
                    self.backgroundPopupView.isHidden = true
                    if oldFlashCard.count == 0 {
                        MagicalRecord.save({context in
                            let wordData = FlashCard.mr_createEntity(in:context)
                            wordData?.id = type == .word ? ".word" : ".flashcard"
                            wordData?.title = type == .word ? "Từ đã lưu" : "FlashCard của tôi"
                            wordData?.avatar =  ""
                        }, completion: {didContext in
                            ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã lưu từ thành công", buttonArray: ["Đóng"], onCompletion: {_ in})
                        })
                    } else {
                        let message =
                            ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã lưu  thành công", buttonArray: ["Đóng"], onCompletion: {_ in})
                    }
                    
                } else {
                    self.backgroundPopupView.isHidden = true
                }
            })

    }
    
    func searchWithGoogle() -> Void {
        var source:String = "ja"
        var target:String = "vi"
        LoadingOverlay.shared.showOverlay(view: self.view)
        let parameter:  [String : String] = ["q":searchText,"key":API_KEY_TRANSLATE_GOOGLE,"source":source,"target":target]
        
        APIManager.sharedInstance.postDataToURL(url: "https://translation.googleapis.com/language/translate/v2", parameters:parameter , onCompletion: {response in
            print(response)
            DispatchQueue.main.async {
                LoadingOverlay.shared.hideOverlayView()
                if (response.result.error != nil) {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: (response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                    })
                }else {
                    let resultDictionary = response.result.value as! [String:AnyObject]
                    let dictResult = resultDictionary["data"] as! [String:AnyObject]
                    let data = dictResult["translations"] as! [AnyObject]
                    if data.count > 0 {
                        let object = data[0] as! [String:AnyObject]
                        let text = object["translatedText"] as! String
                        self.targetTranslateLabel.text = text
                    }
                }
            }
        })
    }
}
