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
    
    var titleArray: [FlashCard]!
    var subWordArray: [FlashCardDetail]!
    var currentHeader = String()
    var audioPlayer : AVAudioPlayer?
    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        DispatchQueue.global().async {
            self.getFlashCard()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleArray = FlashCard.mr_findAll(in: NSManagedObjectContext.mr_default())! as! [FlashCard]
        libraryTableView.reloadData()
    }
    @IBAction func tappedAddDetailLibrary(_ sender: UIButton) {
        libraryTableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray != nil ? titleArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subWordArray != nil ? subWordArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
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
//        if flashCardTitle != nil {
//            headerView?.delegate = self
//            if flashCardTitle.title != nil {
//                headerView?.titleLabel.text = flashCardTitle.title
//            }
//            if flashCardTitle.id != nil {
//                headerView?.backgroundHeaderButton.tag = Int(flashCardTitle.id!)!
//            }
//        }

        ///Thành Lã: 2017/01/05
        guard let cardTitle = flashCardTitle.title, let cardID = flashCardTitle.id else { return nil }
        headerView?.titleLabel.text = cardTitle
        headerView?.backgroundHeaderButton.tag = Int(cardID) ?? 0
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchDerikuStoryboard = UIStoryboard.init(name: "Library", bundle: Bundle.main)
        let detaiVC = searchDerikuStoryboard.instantiateViewController(withIdentifier: "DetailFlashCardViewController") as! DetailFlashCardViewController
        
        let detailTranslate = subWordArray[indexPath.row]
        detaiVC.sound_url = detailTranslate.source_url ?? ""
        detaiVC.word = detailTranslate.word ?? ""
        self.present(detaiVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWordDetail" {

        }
    }
    func tappedShowVocaburaryList(sender: UIButton) {
        currentHeader = String(sender.tag)
        LoadingOverlay.shared.showOverlay(view: view)
//        DispatchQueue.global().async {
            if self.titleArray.count > 1 {
                self.getFlashCardDetail(flashCardId: String(sender.tag))
            } else {
                self.titleArray.removeAll()
                self.subWordArray.removeAll()
                self.getFlashCard()
            }
//        }
    }
    
    /**
     Get Flash Card detail
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
                    let flashCardDetail = FlashCard.mr_createEntity(in: localContext)
                    if let flash_id = flashCardDetailObject["Id"]{
                        flashCardDetail?.id = String(describing: flash_id)
                    }
                    if let Word = flashCardDetailObject["Title"] {
                        flashCardDetail?.title = Word as? String
                    }
                    
                    if let Avatar = flashCardDetailObject["Avatar"] {
                        flashCardDetail?.avatar = Avatar as? String
                    }
                }

            }, completion: {didContext in
                self.titleArray = FlashCard.mr_findAll(in: NSManagedObjectContext.mr_default())! as! [FlashCard]
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
        var parameter : [String:String] = ["secretkey":"nfvsMof10XnUdQEWuxgAZta","action":"get_word_by_flash_cart","flashcartid":flashCardId]
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
                    let flashCardDetail = FlashCardDetail.mr_createEntity()
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
                    if let Meaning = flashCardDetailObject["Meaning"] {
                        flashCardDetail?.meaning = Meaning as? String
                    }
                    if let FlashCardId = flashCardDetailObject["FlashCardId"] {
                        flashCardDetail?.flash_card_id = String(describing: FlashCardId)
                    }
                self.subWordArray = FlashCardDetail.mr_find(byAttribute: "flash_card_id", withValue: self.currentHeader) as! [FlashCardDetail]//(byAttribute: "flash_card_id", withValue: self.currentHeader, in: localContext) as! [FlashCardDetail]
                
//                var parentFlash = FlashCard()
//                for flashCardObject : FlashCard in self.titleArray {
//                    if flashCardObject != nil {
//                        if flashCardObject.id == self.currentHeader {
//                            parentFlash = flashCardObject
//                            break
//                        }
//                    }
//                }
//                self.titleArray.removeAll()
//                self.titleArray.append(parentFlash)
                
                
                ///Editor: Thành Lã - 2017/01/05
                guard let flashCardObject = (self.titleArray.first { $0.id == self.currentHeader }) else { return }
                
                self.titleArray.removeAll()
                self.titleArray.append(flashCardObject)
                
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
