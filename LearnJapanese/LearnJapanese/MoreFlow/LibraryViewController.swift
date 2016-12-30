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

class LibraryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ShowVocaburaryListDelegate {

    @IBOutlet weak var DetailLibraryButton: UIButton!
    @IBOutlet weak var libraryTableView: UITableView!
    var numberOfSection: Int = 2
    
    var titleArray = [FlashCard]()
    var subWordArray = [FlashCardDetail]()
    var currentHeader = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        DispatchQueue.global().async {
            self.getFlashCard()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    @IBAction func tappedAddDetailLibrary(_ sender: UIButton) {
        libraryTableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subWordArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VocabularyTableViewCell", for: indexPath) as! VocabularyTableViewCell
        let word = subWordArray[indexPath.row]
        cell.vocabularyLabel.text = word.word

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options:[:])?.first as? HeaderView
        let flashCardTitle = titleArray[section]
        headerView?.delegate = self
        headerView?.titleLabel.text = flashCardTitle.title
        if flashCardTitle.id != nil {
            headerView?.backgroundHeaderButton.tag = Int(flashCardTitle.id!)!
        }

        return (headerView as? UIView?)!
    }
    
    func tappedShowVocaburaryList(sender: UIButton) {
        currentHeader = String(sender.tag)
        LoadingOverlay.shared.showOverlay(view: view)
        DispatchQueue.global().async {
            if self.titleArray.count > 1 {
                self.getFlashCardDetail(flashCardId: String(sender.tag))
            } else {
                self.titleArray.removeAll()
                self.subWordArray.removeAll()
                self.getFlashCard()
            }
        }
    }
    
    /**
     Get Flash Card detail
     */
    func getFlashCard() {
        var parameter : [String:String] = ["secretkey":"nfvsMof10XnUdQEWuxgAZta","action":"get_flash_cart","pageindex":"1","pagesize":"300"]
        let urlRequest = "http://app-api.dekiru.vn/DekiruApi.ashx"
        DispatchQueue.global().async {
            APIManager.sharedInstance.postDataToURL(url:urlRequest, parameters: parameter, onCompletion: {response in
                if Thread.isMainThread {
                    DispatchQueue.global().async {
                        self.saveFlashCardToDatabase(response:response)
                    }
                } else {
                    self.saveFlashCardToDatabase(response:response)
                }
            })
        }
    }
    
    func saveFlashCardToDatabase(response : DataResponse<Any>) {
        if response.result.error == nil && response.result.isSuccess && response.result.value != nil{
            let resultDictionary = response.result.value! as! [String:AnyObject]
            let dictionaryArray = resultDictionary["Data"] as! [[String : AnyObject]]
            let localContext = NSManagedObjectContext.mr_default()

            localContext.mr_save({localContext in
                for flashCardDetailObject in dictionaryArray {
                    let flashCardDetail = FlashCard.mr_createEntity()
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
                self.titleArray = (FlashCard.mr_findAll() as? [FlashCard])!
                DispatchQueue.main.async {
                    LoadingOverlay.shared.hideOverlayView()
                    self.libraryTableView.reloadData()
                }
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
                    if Thread.isMainThread {
                        DispatchQueue.global().async {
                            self.saveFlashCardDetailToDatabase(response:response)
                        }
                    } else {
                        self.saveFlashCardDetailToDatabase(response:response)
                    }
                })
            }
        }
    
    func saveFlashCardDetailToDatabase(response : DataResponse<Any>) {
        if response.result.error == nil && response.result.isSuccess && response.result.value != nil{
            let resultDictionary = response.result.value! as! [String:AnyObject]
            let dictionaryArray = resultDictionary["Data"] as! [[String : AnyObject]]
            let localContext = NSManagedObjectContext.mr_default()
            
            localContext.mr_save({localContext in
                for flashCardDetailObject in dictionaryArray {
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
                        flashCardDetail?.avatar = Romaji as? String
                    }
                    if let Kana = flashCardDetailObject["Kana"] {
                        flashCardDetail?.avatar = Kana as? String
                    }
                    if let SoundUrl = flashCardDetailObject["SoundUrl"] {
                        flashCardDetail?.avatar = SoundUrl as? String
                    }
                    if let Meaning = flashCardDetailObject["Meaning"] {
                        flashCardDetail?.meaning = Meaning as? String
                    }
                    if let FlashCardId = flashCardDetailObject["FlashCardId"] {
                        flashCardDetail?.flash_card_id = String(describing: FlashCardId)
                    }
                }
                
                self.subWordArray = FlashCardDetail.mr_find(byAttribute: "flash_card_id", withValue: self.currentHeader) as! [FlashCardDetail]//(byAttribute: "flash_card_id", withValue: self.currentHeader, in: localContext) as! [FlashCardDetail]
                
                var parentFlash = FlashCard()
                for flashCardObject : FlashCard in self.titleArray {
                    if flashCardObject.id == self.currentHeader {
                        parentFlash = flashCardObject
                        break
                    }
                }
                self.titleArray.removeAll()
                self.titleArray.append(parentFlash)
                DispatchQueue.main.async {
                    LoadingOverlay.shared.hideOverlayView()
                    self.libraryTableView.reloadData()
                }
            })
            
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
}
