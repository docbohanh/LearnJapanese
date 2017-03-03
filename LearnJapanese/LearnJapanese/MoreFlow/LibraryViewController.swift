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
    var iconArray = [UIImage]()
    
    var soundIndex = 0
    var timer: Timer?
    var sourceSound: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        libraryTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        DispatchQueue.global().async {
            if let oldFlashCard = FlashCard.mr_find(byAttribute: "id", withValue: ".flashcard") {
                if oldFlashCard.count == 0 {
                    MagicalRecord.save({context in
                        let wordData = FlashCard.mr_createEntity(in:context)
                        wordData?.id = ".flashcard"
                        wordData?.title = "FlashCard của tôi"
                        wordData?.avatar =  ""
                    }, completion: {didContext in
                        if let oldWord = FlashCard.mr_find(byAttribute: "id", withValue: ".word") {
                            if oldWord.count == 0 {
                                MagicalRecord.save({context in
                                    let wordData = FlashCard.mr_createEntity(in:context)
                                    wordData?.id = ".word"
                                    wordData?.title = "Từ đã lưu"
                                    wordData?.avatar =  ""
                                })
                            }
                        }
                    })
                }
            }
            self.getFlashCard()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LoadingOverlay.shared.showOverlay(view: self.view)
        self.titleArray = FlashCard.mr_findAllSorted(by: "id", ascending: true) as! [FlashCard]
        if subWordArray != nil {
            if subWordArray.count > 0 {
                subWordArray.removeAll()
            }
        }
        if iconArray != nil {
            if iconArray.count > 0 {
                iconArray.removeAll()
            }
        }
        self.iconArray.append(UIImage.init(named: "icon_flashcash_folder")!)
        self.iconArray.append(UIImage.init(named: "icon_flashcash_folder")!)
        
        subWordArray = FlashCardDetail.mr_find(byAttribute: "flash_card_id", withValue: currentIdFlashCard, andOrderBy: "id", ascending: true) as! [FlashCardDetail]!
        LoadingOverlay.shared.hideOverlayView()
        
        self.libraryTableView.reloadData()
        self.tabBarController?.tabBar.isHidden = false
        DispatchQueue.global().async {

            if self.titleArray.count > 2 {
                for index in 2..<self.titleArray.count {
                    let flashCardTitle = self.titleArray[index]
                    if flashCardTitle.avatar != nil {
                        self.loadIconImage(url: flashCardTitle.avatar!,section: index)
                    }
                }
            }

        }
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
            if (word.avatar != nil) {
                cell.favoriteIconImageView?.loadImage(url: word.avatar!)
            }
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options:[:])?.first as? HeaderView
        let flashCardTitle = titleArray[section]
        headerView?.delegate = self
        guard let cardTitle = flashCardTitle.title, let cardID = flashCardTitle.id else { return nil }
        if section == 0 {
            headerView?.flashCard = ".flashcard"
            headerView?.iconHeaderImageView.image = UIImage.init(named: "icon_flashcash_folder")
        } else if section == 1 {
            headerView?.flashCard = ".word"
            headerView?.iconHeaderImageView.image = UIImage.init(named: "icon_flashcash_folder")
        } else {
            
            if (flashCardTitle.avatar != nil) {
                if (iconArray.count) > section {
                    headerView?.iconHeaderImageView.image = iconArray[section]
                }
//                headerView?.iconHeaderImageView.loadImage(url:flashCardTitle.avatar!)
            }
        }
        headerView?.titleLabel.text = cardTitle
        headerView?.backgroundHeaderButton.tag = Int(cardID) ?? 0
        headerView?.tag = section
        headerView?.playSoundButton.tag = Int(cardID) ?? 0
        headerView?.playSoundButton.addTarget(self, action: #selector(self.playList(_:)), for: .touchUpInside)
        
        return headerView
    }
    
    //MARK:
    
    func playWordSound(_ url: URL) {
        let playerItem = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem:playerItem)
        self.player.rate = 1.0
        self.player.play()
    }
    
    ///
    func playSourceSound() {
        
        soundIndex += 1
        
        guard soundIndex < sourceSound.count else {
            timer?.invalidate()
            soundIndex = 0
            
            ProjectCommon.initAlertView(
                viewController: self,
                title: "",
                message: "Đã đọc xong",
                buttonArray: ["OK"],
                onCompletion: { (index) in }
            )
            
            return
        }
        
        print("url \(soundIndex): \(sourceSound[soundIndex])")
        playWordSound(sourceSound[soundIndex])
        
    }
    
    ///
    func playList(_ sender: UIButton) {
        soundIndex = 0
        timer?.invalidate()
        
        getSoundSourceUrl(id: sender.tag) { [unowned self] in
            
            delay(0.3.second) {
                guard self.sourceSound.count > 0 else { return }
                
                print("url-->0: \(self.sourceSound[0])")
                self.playWordSound(self.sourceSound[0])
                
                if let timer = self.timer { timer.invalidate() }
                
                self.timer = Timer.scheduledTimer(
                    timeInterval: 3.second,
                    target: self,
                    selector: #selector(self.playSourceSound),
                    userInfo: nil,
                    repeats: true
                )
            }
        }
        
        
    }
    
    ///
    func getSoundSourceUrl(id: Int, completion: (() -> Void)? = nil) {
        
        let parameter : [String: String]  = ["secretkey": "nfvsMof10XnUdQEWuxgAZta",
                                            "action": "get_word_by_flash_cart",
                                            "flashcartid": String(id)]
        
        let urlRequest = "http://app-api.dekiru.vn/DekiruApi.ashx"
        
        
        APIManager.sharedInstance.postDataToURL(url:urlRequest, parameters: parameter, onCompletion: { response in
            
            guard let json = response.result.value else { return }

            do {
                let trans = try DataSoundJSON(JSONObject: json)
                
                self.sourceSound = trans.sound.map { $0.soundUrl }.flatMap { URL(string: $0) }
                
                print("sound counted: \(self.sourceSound.count)")
                
            } catch {
                print(error)
            }
            
        })
        
        if let completion = completion { completion() }
        
    }
    
    
    func loadIconImage(url:String,section:Int) -> Void {
        let catPictureURL = URL(string: url)!
        let session = URLSession(configuration: .default)
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        DispatchQueue.main.async {
                            self.libraryTableView.reloadSections(IndexSet.init(integer:section), with: UITableViewRowAnimation.none)
                            self.iconArray.append(UIImage.init(data: data!)!)
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isShowListWord && currentIdFlashCard == ".word"{
            let flashCardDetail = subWordArray[indexPath.row]
            
            let searchDerikuStoryboard = UIStoryboard.init(name: "SearchDekiru", bundle: Bundle.main)
            let detaiVC = searchDerikuStoryboard.instantiateViewController(withIdentifier: "WordDetailViewController") as! WordDetailViewController
            detaiVC.searchText = flashCardDetail.word ?? ""
            detaiVC.wordId = flashCardDetail.id ?? ""
            self.navigationController?.pushViewController(detaiVC, animated: true)
        } else {
            let searchDerikuStoryboard = UIStoryboard.init(name: "Library", bundle: Bundle.main)
            let detaiVC = searchDerikuStoryboard.instantiateViewController(withIdentifier: "DetailFlashCardViewController") as! DetailFlashCardViewController
            detaiVC.listWord = subWordArray
            if currentIdFlashCard == ".flashcard" {
                detaiVC.isFlashCard = true
//                detaiVC.isMyWord = true
            } else {
                detaiVC.isFlashCard = false
            }
            detaiVC.currentIndexWord = indexPath.row
            self.navigationController?.pushViewController(detaiVC, animated: true)
        }

    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if isShowListWord && currentIdFlashCard == ".flashcard" {
            return true
        } else {
        return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if isShowListWord && currentIdFlashCard == ".flashcard" {
            if editingStyle == .delete {
                if subWordArray.count > indexPath.row  {
                    let object = subWordArray[indexPath.row]
                    
                    let localContext = NSManagedObjectContext.mr_default()
                    object.mr_deleteEntity(in: localContext)
                    localContext.mr_saveToPersistentStoreAndWait()
                    subWordArray.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }

            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWordDetail" {
        }
    }
    
    func tappedShowVocaburaryList(sender: HeaderView, flashCard: String) {
        
        timer?.invalidate()
        
        if ProjectCommon.connectedToNetwork() {
            selectedSection = sender.tag
            let button = sender.backgroundHeaderButton as UIButton
            currentIdFlashCard = String(button.tag)
            isShowListWord = !isShowListWord
            //isMyWord = false
            if isShowListWord {
                if subWordArray != nil {
                    if subWordArray.count > 0 {
                        subWordArray.removeAll()
                    }
                }
                LoadingOverlay.shared.showOverlay(view: view)
                if flashCard == ".flashcard" {
                    currentIdFlashCard = ".flashcard"
                    subWordArray = FlashCardDetail.mr_find(byAttribute: "flash_card_id", withValue: currentIdFlashCard, andOrderBy: "id", ascending: true) as! [FlashCardDetail]!

                    LoadingOverlay.shared.hideOverlayView()
                    self.libraryTableView.reloadData()
                } else if flashCard == ".word" {
                    currentIdFlashCard = ".word"
                    if subWordArray != nil {
                        if subWordArray.count > 0 {
                            subWordArray.removeAll()
                        }
                    }
                    subWordArray = FlashCardDetail.mr_find(byAttribute: "flash_card_id", withValue: currentIdFlashCard, andOrderBy: "id", ascending: true) as! [FlashCardDetail]!
                    //isMyWord = true
                    LoadingOverlay.shared.hideOverlayView()
                    self.libraryTableView.reloadData()
                } else {
                    self.getFlashCardDetail(flashCardId: currentIdFlashCard)
                }
            } else {
                if subWordArray != nil {
                    if subWordArray.count > 0 {
                        subWordArray.removeAll()
                    }
                }
                libraryTableView.reloadData()
            }
        } else {
            ProjectCommon.initAlertView(viewController: self, title: "", message: "Không thể kết nối internet,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: {_ in
            })
        }
    }
    
    func tappedPlaySoundList(sender: UIButton) {
        
//        let object = subWordArray[index]
//        if object.source_url != nil {
//            let url = object.source_url
//            let playerItem = AVPlayerItem( url:URL(string:url! )!)
//            self.player = AVPlayer(playerItem:playerItem)
//            self.player.rate = 1.0;
//            self.player.play()
//        }else {
//            ProjectCommon.initAlertView(viewController: self, title: "", message: "Không tồn tại âm thanh này", buttonArray: ["OK"], onCompletion: { (index) in
//            })
//        }
    }
    
    /**
     Get All Flash Card
     */
    func getFlashCard() {
        let parameter : [String:String] = ["secretkey":"nfvsMof10XnUdQEWuxgAZta","action":"get_flash_cart","pageindex":"1","pagesize":"300"]
        let urlRequest = "http://api-app.dekiru.vn/DekiruApi.ashx"
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
                            flashCard?.avatar = Avatar as! String
                        }
                    }
 
                }
            }, completion: {didContext in
                LoadingOverlay.shared.showOverlay(view: self.view)
                self.titleArray = FlashCard.mr_findAllSorted(by: "id", ascending: true) as! [FlashCard]
                
                LoadingOverlay.shared.hideOverlayView()
                self.libraryTableView.reloadData()
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã tải thành công các chủ đề", buttonArray: ["Đóng"], onCompletion: { _ in
                })
                DispatchQueue.global().async {
//                    for word in self.titleArray {
//                        if word.avatar != nil && (word.avatar?.characters.count)! > 0 {
//                            self.loadImage(url: word.avatar!)
//                        }
//                    }
                    DispatchQueue.main.async {
                        LoadingOverlay.shared.hideOverlayView()
                        self.libraryTableView.reloadData()
                    }
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
            if flashDetail.source_url == nil || flashDetail.source_url?.characters.count == 0 {
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
