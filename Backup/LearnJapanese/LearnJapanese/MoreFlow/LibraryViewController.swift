//
//  LibraryViewController.swift
//  LearnJapanese
//
//  Created by Nguyen Hai Dang on 11/29/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import MagicalRecord
import Alamofire
import AVFoundation

class LibraryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ShowVocaburaryListDelegate,VocabularyCellDelegate {

    @IBOutlet weak var DetailLibraryButton: UIButton!
    @IBOutlet weak var libraryTableView: UITableView!
    var numberOfSection: Int = 2
    
    var titleArray : [FlashCard]!
    var subWordArray : [FlashCardDetail]!
    var currentIdFlashCard = String()
    var audioPlayer : AVAudioPlayer?
    var player: AVPlayer!
    var isShowListWord = false
    var selectedSection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        DispatchQueue.global().async {
            self.getFlashCard()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        titleArray = FlashCard.mr_findAll(in: NSManagedObjectContext.mr_default())! as! [FlashCard]
//        libraryTableView.reloadData()
    }
    @IBAction func tappedAddDetailLibrary(_ sender: UIButton) {
        libraryTableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray != nil ? titleArray.count : 0

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == selectedSection {
            return subWordArray != nil ? subWordArray.count : 0
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isShowListWord {
            if section == selectedSection {
                return 60
            }else {
                return 0
            }
        }else {
             return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VocabularyTableViewCell", for: indexPath) as! VocabularyTableViewCell
        if subWordArray.count > indexPath.row {
            let word = subWordArray[indexPath.row]
            cell.vocabularyLabel.text = word.word
            cell.readVocabulary.tag = 312 + indexPath.row
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options:[:])?.first as? HeaderView
        let flashCardTitle = titleArray[section]
        headerView?.delegate = self

        ///Thành Lã: 2017/01/05
        guard let cardTitle = flashCardTitle.title, let cardID = flashCardTitle.id else { return nil }
        headerView?.titleLabel.text = cardTitle
        headerView?.backgroundHeaderButton.tag = Int(cardID) ?? 0
        headerView?.tag = section
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchDerikuStoryboard = UIStoryboard.init(name: "Library", bundle: Bundle.main)
        let detaiVC = searchDerikuStoryboard.instantiateViewController(withIdentifier: "DetailFlashCardViewController") as! DetailFlashCardViewController
        detaiVC.listWord = subWordArray
        detaiVC.currentIndexWord = indexPath.row
        self.present(detaiVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWordDetail" {

        }
    }
    func tappedShowVocaburaryList(sender: HeaderView) {
        selectedSection = sender.tag
        let button = sender.backgroundHeaderButton as UIButton
        currentIdFlashCard = String(button.tag)
        isShowListWord = !isShowListWord
        if isShowListWord {
            if subWordArray != nil {
                if subWordArray.count > 0 {
                    subWordArray.removeAll()
                }
            }
            LoadingOverlay.shared.showOverlay(view: view)
            self.getFlashCardDetail(flashCardId: currentIdFlashCard)
        } else {
            if subWordArray != nil {
                if subWordArray.count > 0 {
                    subWordArray.removeAll()
                }
            }
            libraryTableView.reloadData()
        }
    }
    
    /**
     Get All Flash Card
     */
    func getFlashCard() {
        let parameter : [String:String] = ["secretkey":"nfvsMof10XnUdQEWuxgAZta","action":"get_flash_cart","pageindex":"1","pagesize":"300"]
        let urlRequest = "http://app-api.dekiru.vn/DekiruApi.ashx"
        DispatchQueue.global().async {
            APIManager.sharedInstance.postDataToURL(url:urlRequest, parameters: parameter, onCompletion: {response in
                    self.saveFlashCardToDatabase(response:response)
            })
        }
    }
    
    func saveFlashCardToDatabase(response : DataResponse<Any>) {
        if response.result.error == nil && response.result.isSuccess && response.result.value != nil{
            let resultDictionary = response.result.value! as! [String:AnyObject]
            let dictionaryArray = resultDictionary["Data"] as! [[String : AnyObject]]
            MagicalRecord.save({localContext in
                for flashCardDetailObject in dictionaryArray {
                    var flashCard : FlashCard!
                    if flashCardDetailObject["Id"] != nil {
                        let foundFlashCard = FlashCard.mr_find(byAttribute: "id", withValue: String(describing: flashCardDetailObject["Id"]!)) as! [FlashCard]
                        if foundFlashCard.count > 0 {
                            flashCard = foundFlashCard[0]
                        }else {
                            flashCard = FlashCard.mr_createEntity(in:localContext)
                        }
                        if let flash_id = flashCardDetailObject["Id"]{
                            flashCard?.id = String(describing: flash_id)
                        }
                        if let Word = flashCardDetailObject["Title"] {
                            flashCard?.title = Word as? String
                        }
                        
                        if let Avatar = flashCardDetailObject["Avatar"] {
                            flashCard?.avatar = Avatar as? String
                        }
                    }
 
                }
            }, completion: {didContext in
                self.titleArray = FlashCard.mr_findAllSorted(by: "id", ascending: true) as! [FlashCard]
                LoadingOverlay.shared.hideOverlayView()
                self.libraryTableView.reloadData()
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã tải thành công các chủ đề", buttonArray: ["Đóng"], onCompletion: { _ in
                })
            })
            } else {
            DispatchQueue.main.async {
                LoadingOverlay.shared.hideOverlayView()
            }
        }
    }
    
    /**
     Get Flash Card detail
     */
    func getFlashCardDetail(flashCardId:String) {
        let parameter : [String:String] = ["secretkey":"nfvsMof10XnUdQEWuxgAZta","action":"get_word_by_flash_cart","flashcartid":flashCardId]
        let urlRequest = "http://app-api.dekiru.vn/DekiruApi.ashx"
            DispatchQueue.global().async {
                APIManager.sharedInstance.postDataToURL(url:urlRequest, parameters: parameter, onCompletion: {response in
                    self.saveFlashCardDetailToDatabase(response:response)
                })
            }
        }
    
    func saveFlashCardDetailToDatabase(response : DataResponse<Any>) {
        if response.result.error == nil && response.result.isSuccess && response.result.value != nil{
            let resultDictionary = response.result.value! as! [String:AnyObject]
            let dictionaryArray = resultDictionary["Data"] as! [[String : AnyObject]]
            let localContext = NSManagedObjectContext.mr_default()
            
             for flashCardDetailObject in dictionaryArray {
            localContext.mr_save(blockAndWait:{localContext in
                var flashCardDetail : FlashCardDetail!
                if flashCardDetailObject["Id"] != nil {
                    let foundFlashCard = FlashCardDetail.mr_find(byAttribute: "id", withValue: String(describing: flashCardDetailObject["Id"]!)) as! [FlashCardDetail]
                    if foundFlashCard.count > 0 {
                        flashCardDetail = foundFlashCard[0]
                    }else {
                        flashCardDetail = FlashCardDetail.mr_createEntity(in:localContext)
                    }
                    
                    if let Id = flashCardDetailObject["Id"]{
                        flashCardDetail?.id = String(describing: Id)
                    }
                    if let Word = flashCardDetailObject["Word"] {
                        flashCardDetail?.word = Word as? String
                    }
                    if let Avatar = flashCardDetailObject["Avatar"] {
                        flashCardDetail?.avatar = Avatar as? String
                    }
                    if let Romaji = flashCardDetailObject["Romaji"] {
                        flashCardDetail?.romaji = Romaji as? String
                    }
                    if let Kana = flashCardDetailObject["Kana"] {
                        flashCardDetail?.kana = Kana as? String
                    }
                    if let SoundUrl = flashCardDetailObject["SoundUrl"] {
                        flashCardDetail?.source_url = SoundUrl as? String
                    }
                    if let Meaning = flashCardDetailObject["WordMeaning"] {
                        flashCardDetail?.meaning = Meaning as? String
                    }
                    if let FlashCardId = flashCardDetailObject["FlashCardId"] {
                        flashCardDetail?.flash_card_id = String(describing: FlashCardId)
                    }
                    //                self.subWordArray = FlashCardDetail.mr_find(byAttribute: "flash_card_id", withValue: self.currentIdFlashCard) as! [FlashCardDetail]
                    self.subWordArray = FlashCardDetail.mr_find(byAttribute: "flash_card_id", withValue: self.currentIdFlashCard, andOrderBy: "id", ascending: true) as![FlashCardDetail]
                    ///Editor: Thành Lã - 2017/01/05
                    guard let flashCardObject = (self.titleArray.first { $0.id == self.currentIdFlashCard }) else { return }
                }
                })
            }

            DispatchQueue.main.async {
                LoadingOverlay.shared.hideOverlayView()
                self.libraryTableView.reloadData()
            }
        } else {
            DispatchQueue.main.async {
                LoadingOverlay.shared.hideOverlayView()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudio(int: Int) {
        DispatchQueue.main.async {
            let flashDetail = self.subWordArray[int]
            if flashDetail.source_url == nil {
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Không tồn tại âm thanh này", buttonArray: ["Đóng"], onCompletion: {_ in 
                })
            } else {
                let url = flashDetail.source_url
                let playerItem = AVPlayerItem( url:URL(string:url! )! )
                self.player = AVPlayer(playerItem:playerItem)
                self.player.rate = 1.0;
                self.player.play()
            }
        }
    }
}
