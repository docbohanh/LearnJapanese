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
    
    var libraryListArray = [["value":["なぜですか","いつですか","どきですか"],"key":"FlashCard của tôi"],["key":"từ đã lưu","value":["なぜですか","いつですか"]],["key":"chủ đề 1","value":["お願いします","どちらですか","始めますて","こ日は"]]]
    var currentLibraryArray = [["value":["なぜですか","いつですか","どきですか"],"key":"FlashCard của tôi"],["key":"từ đã lưu","value":["なぜですか","いつですか"]],["key":"chủ đề 1","value":["お願いします","どちらですか","始めますて","こ日は"]]]
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        for index in 0..<currentLibraryArray.count {
            currentLibraryArray[index].removeValue(forKey: "value")
        }
        DispatchQueue.global().async {
        
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tappedAddDetailLibrary(_ sender: UIButton) {
        currentLibraryArray.removeAll()
        currentLibraryArray = libraryListArray
        for index in 0..<currentLibraryArray.count {
            currentLibraryArray[index].removeValue(forKey: "value")
        }
        libraryTableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return currentLibraryArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = Int()
        for index in 0..<currentLibraryArray.count {
            if let value = currentLibraryArray[index]["value"] {
                numberOfRow += 1
            }
        }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VocabularyTableViewCell", for: indexPath) as! VocabularyTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options:[:])?.first as? HeaderView
        headerView?.delegate = self
        headerView?.titleLabel.text = currentLibraryArray[section]["key"] as! String?
        headerView?.backgroundHeaderButton.tag = 500 + section
        return (headerView as? UIView?)!
    }
    
    func tappedShowVocaburaryList(sender: UIButton) {
        currentLibraryArray.removeAll()
        currentLibraryArray.append(libraryListArray[sender.tag - 500])
        libraryTableView.reloadData()
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
    }
    
    func saveFlashCardDetailToDatabase(response : DataResponse<Any>) {
        if response.result.error == nil && response.result.isSuccess && response.result.value != nil{
            let resultDictionary = response.result.value! as! [String:AnyObject]
            let dictionaryArray = resultDictionary["Data"] as! [[String : AnyObject]]
            
            for flashCardDetailObject in dictionaryArray {
                let localContext = NSManagedObjectContext.mr_default()
                let flashCardDetail = FlashCardDetail.mr_createEntity()
                localContext.mr_save({localContext in
                    if let flash_id = flashCardDetailObject["FlashCardId"]{
                        flashCardDetail?.id = flash_id as? String
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
                        flashCardDetail?.avatar = Meaning as? String
                    }
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
