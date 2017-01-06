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
    
    var searchText : String = ""
    var wordId: String = ""
    var detailTranslate: Translate!
    var detailFlashCard: Translate!
    var player: AVPlayer!
    
    
    var popupView : SavePopupView?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.text = searchText
        // Do any additional setup after loading the view.
        self.setupViewController()
        DispatchQueue.global().async {
            if self.detailTranslate != nil {
                self.saveHistoryData(translate: self.detailTranslate)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 4
        searchTextField.layer.borderColor = UIColor.white.cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true

        DispatchQueue.global().async {
            
            let detailTranslate = Translate.mr_find(byAttribute: "id", withValue: self.wordId)?.first as? Translate
            DispatchQueue.main.async {
                
                self.meaningLabel.text = detailTranslate?.meaning_name
                self.examplelabel.text = detailTranslate?.example_meaning_name
                self.titleLabel.text = self.searchText
            }
        }
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
        if detailTranslate.sound_url == nil || detailTranslate.sound_url?.characters.count == 0 {
            ProjectCommon.initAlertView(viewController: self, title: "", message: "Không tồn tại âm thanh này", buttonArray: ["Đóng"], onCompletion: {_ in
            })
        } else {
            let playerItem = AVPlayerItem( url:URL(string:detailTranslate.sound_url! )! )
            self.player = AVPlayer(playerItem:playerItem)
            self.player.rate = 1.0;
            self.player.play()
        }
    }
    @IBAction func tappedFavoriteButton(_ sender: Any) {
        popupView?.wordLabel.text = searchTextField.text
        backgroundPopupView.isHidden = false
        popupView?.meaningTextView.text = detailTranslate.meaning_name
        popupView?.myFlashCardsLabel.text = "Lưu từ"
        popupView?.storeType = .word
    }
    @IBAction func tappedSaveFlashCashButton(_ sender: Any) {
        popupView?.wordLabel.text = searchTextField.text
        popupView?.meaningTextView.text = detailTranslate.meaning_name
        backgroundPopupView.isHidden = false
        popupView?.myFlashCardsLabel.text = "Flash Cards của tôi"
        popupView?.storeType = .flash_card
        self.saveWordToLocal(type: .flash_card)
    }
    @IBAction func tappedClosePopupButton(_ sender: Any) {
        backgroundPopupView.isHidden = true
    }
    @IBAction func tappedDekiruDictButton(_ sender: Any) {
        searchWebView.isHidden = true
        searchResultScrollView.isHidden = false
    }
    @IBAction func tappedGoogleButton(_ sender: Any) {
        searchResultScrollView.isHidden = true
        searchWebView.isHidden = false
        let url = NSURL (string: "https://translate.google.com");
        let requestObj = NSURLRequest(url: url! as URL);
        searchWebView.loadRequest(requestObj as URLRequest);
    }
    @IBAction func tappedWikipediaButton(_ sender: Any) {
        searchResultScrollView.isHidden = true
        searchWebView.isHidden = false
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
        searchResultScrollView.isHidden = true
        searchWebView.isHidden = false
        let wordSearch = searchTextField.text ?? "dekiru"

        let url = NSURL (string: "http://www.bing.com/search?q=" + wordSearch);
        if url != nil {
            let requestObj = NSURLRequest(url: url! as URL);
            searchWebView.loadRequest(requestObj as URLRequest);
        }

    }

    func saveHistoryData(translate:Translate) {
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
    
    func saveWordToLocal(type: MyStoreType) {
        let localContext = NSManagedObjectContext()
        let oldFlashCard = FlashCard.mr_find(byAttribute: "id", withValue: "myWord")
        if oldFlashCard == nil {
            MagicalRecord.save({localContext in
                let wordData = FlashCard.mr_createEntity(in:localContext)
                wordData?.id = type == .word ? "word" : "flashcard"
                wordData?.title = "Từ đã lưu"
                wordData?.avatar =  ""
            }, completion: {didContext in
                self.backgroundPopupView.isHidden = true
                MagicalRecord.save({localContext in
                    let wordData = FlashCardDetail.mr_createEntity(in:localContext)
                    wordData?.kana = self.detailTranslate.kana ?? ""
                    wordData?.word = self.detailTranslate.word ?? ""
                    wordData?.source_url = self.detailTranslate.sound_url ?? ""
                    wordData?.meaning = self.detailTranslate.meaning_name ?? ""
                    wordData?.romaji = self.detailTranslate.romaji ?? ""
                    wordData?.id = self.detailTranslate.id ?? ""
                    
                    if type == .flash_card {
                        wordData?.flash_card_id = "flashcard"
                    } else {
                        wordData?.flash_card_id = "word"
                        
                    }
                }, completion: {didContext in
                    self.backgroundPopupView.isHidden = true
                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã lưu từ thành công", buttonArray: ["Đóng"], onCompletion: {_ in})
                })
            })
        } else {
            MagicalRecord.save({localContext in
                let wordData = FlashCardDetail.mr_createEntity(in:localContext)
                wordData?.kana = self.detailTranslate.kana ?? ""
                wordData?.word = self.detailTranslate.word ?? ""
                wordData?.source_url = self.detailTranslate.sound_url ?? ""
                wordData?.meaning = self.detailTranslate.meaning_name ?? ""
                wordData?.romaji = self.detailTranslate.romaji ?? ""
                wordData?.id = self.detailTranslate.id ?? ""
                
                if type == .flash_card {
                    wordData?.flash_card_id = "flashcard"
                } else {
                    wordData?.flash_card_id = "word"
                    
                }
            }, completion: {didContext in
                self.backgroundPopupView.isHidden = true
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã lưu từ thành công", buttonArray: ["Đóng"], onCompletion: {_ in})
            })

        }

        
    }
}
