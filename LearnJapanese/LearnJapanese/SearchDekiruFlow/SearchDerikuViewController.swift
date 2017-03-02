//
//  SearchDerikuViewController.swift
//  LearnJapanese
//
//  Created by Thuy Phan on 11/29/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import MagicalRecord
import Alamofire

class SearchDerikuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var changeLangueButton: UIButton!
    @IBOutlet weak var notFoundView: UIView!
    @IBOutlet weak var notFoundResultLabel: UILabel!
    @IBOutlet weak var introduceView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var deleteSearchButton: UIButton!
    @IBOutlet weak var searchTextfield: UITextField!
    
    @IBOutlet weak var paintSearchButton: UIButton!
    @IBOutlet weak var recordSearchButton: UIButton!
    @IBOutlet weak var photoSearchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var popupView = SavePopupView()
    var wordArray: [Translate]!
    var searchPlaceArray = [[Translate]!]()
    var oldSearchString:String = ""
    var currentSearchString = ""
    
    
    var firstArray = [Translate]()
    var secondArray = [Translate]()
    var searchWordArray = [Translate]()
    var filterArray = [Translate]()
    var searchActive = false
    var currentDetailTranslate: Translate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("search Dekiru")
        // Do any additional setup after loading the view.
        tableView .register(UINib.init(nibName: "WordSearchTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "WordSearchTableViewCell")
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        popupView = Bundle.main.loadNibNamed("SavePopupView", owner: self, options: nil)?.first as! SavePopupView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        //        searchBarView.layer.cornerRadius = 5
        //        searchBarView.layer.borderWidth = 1
        //        searchBarView.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        if self.wordArray != nil {
            if self.wordArray.count == 0 {
                self.getWordFromDatabase()
            }
        } else {
            self.getWordFromDatabase()
        }
        self.addFlashCard()
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        if tableView != nil {
            tableView.reloadData()
        }
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tappedAddNewWord(_ sender: UIButton) {
        if ProjectCommon.connectedToNetwork(){
            ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã báo cáo từ chưa có.", buttonArray: ["Đóng"], onCompletion: {_ in

            })
        } else {
            ProjectCommon.initAlertView(viewController: self, title: "", message: "Không thể kết nối đến máy chủ", buttonArray:["Đóng"], onCompletion: {_ in
                
            })
        }
    }
    
    @IBAction func tappedChangedLangue(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        tableView.reloadData()
        self.searchBar(searchBar, textDidChange: searchBar.text ?? "")
    }
    
    @IBAction func tappedSearchWithGoogle(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Translate", bundle: nil)
        let translateViewController = storyboard.instantiateViewController(withIdentifier: "TranslateViewController") as! TranslateViewController
        self.tabBarController?.selectedIndex = 2
        
    }
    
    func sendRequest(url: String, parameters: [String: String], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTask {
        let parameterString = parameters.stringFromHttpParameters()
        let requestURL = URL(string:"\(url)?\(parameterString)")!
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
        
        return task
    }
    
    /* =============== ACTION BUTTON CLICKED =============== */
    @IBAction func searchButton_clicked(_ sender: Any) {
        if (searchTextfield.text?.characters.count)! > 0 {
        }
    }
    
    @IBAction func deleteSearchButton_clicked(_ sender: Any) {
        searchTextfield.text = ""
    }
    
    @IBAction func paintSearchButton_clicked(_ sender: Any) {
    }
    
    @IBAction func recordSearchButton_clicked(_ sender: Any) {
    }
    
    @IBAction func photoSearchButton_clicked(_ sender: Any) {
    }
    /* ===================================================== */
    
    /* =============== TABLEVIEW DATASOURCE =============== */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return arrayWord.count
        return filterArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let strIdentifer = "WordSearchTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: strIdentifer, for: indexPath) as! WordSearchTableViewCell
        if filterArray.count > indexPath.row {
            let translate = filterArray[indexPath.row]
            
            if searchActive {
                
                if changeLangueButton.isSelected {
                    cell.wordLabel.text = translate.meaning_name
                    cell.contentLabel.text = translate.word
                } else {
                    cell.wordLabel.text = translate.word
                    cell.contentLabel.text = translate.meaning_name
                }
            }else {
                if changeLangueButton.isSelected {
                    cell.wordLabel.text = translate.meaning_name
                    cell.contentLabel.text = translate.word
                } else {
                    cell.wordLabel.text = translate.word
                    cell.contentLabel.text = translate.meaning_name
                }
                
            }
            if translate.isSearch == nil || translate.isSearch == "0"{
                
                cell.initCell(wordModel: WordModel())
            } else {
                cell.initCell(wordModel: WordModel())
                cell.iconImageView.image = UIImage.init(named: "icon_history")

            }

        }
         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filterArray.count > indexPath.row {
            let searchDerikuStoryboard = UIStoryboard.init(name: "SearchDekiru", bundle: Bundle.main)
            let detaiVC = searchDerikuStoryboard.instantiateViewController(withIdentifier: "WordDetailViewController") as! WordDetailViewController
            currentDetailTranslate = filterArray[indexPath.row]
            detaiVC.searchText = currentDetailTranslate.word ?? ""
            detaiVC.wordId = currentDetailTranslate.id ?? ""
            if currentDetailTranslate != nil {
                self.updateWordToHistory(index:indexPath.row)
            }
            self.navigationController?.pushViewController(detaiVC, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.characters.count)! > 0 {
            self.introduceView.isHidden = true
        }
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "gotoWordDetail" {
//            let wordDetailViewController = segue.destination as? WordDetailViewController
//            wordDetailViewController?.searchText = searchTextfield.text!
//            wordDetailViewController?.wordId = currentDetailTranslate.id ?? ""
//        }
    }
    
    func updateWordToHistory(index:Int) {
        let word = Translate.mr_find(byAttribute: "id", withValue: self.currentDetailTranslate.id, in: NSManagedObjectContext.mr_default())?.first as? Translate
        if word != nil {
            word?.isSearch = "1"
        }
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
    
    func getWordFromDatabase() {
        LoadingOverlay.shared.showOverlay(view: self.view)
        wordArray = Translate.mr_findAllSorted(by: "romaji", ascending: true, in: NSManagedObjectContext.mr_default()) as! [Translate]
        if wordArray.count > 4001 {
            let oneArray:[Translate]! = Array(wordArray[0...4000])
            searchPlaceArray.append(oneArray)
        }
        if wordArray.count > 4001 {
            let twoArray:[Translate]! = Array(wordArray[4001...7000])
            searchPlaceArray.append(twoArray)
        }
        if wordArray.count > 4001 {
            let threeArray:[Translate]! = Array(wordArray[7001...10000])
            searchPlaceArray.append(threeArray)
        }
        if wordArray.count > 4001 {
            let fourArray:[Translate]! = Array(wordArray[10001...13000])
            searchPlaceArray.append(fourArray)
        }
        if wordArray.count > 4001 {
            let fineArray:[Translate]! = Array(wordArray[13001...17000])
            searchPlaceArray.append(fineArray)
        }
        if wordArray.count > 4001 {
            let sixArray:[Translate]! = Array(wordArray[17001...21000])
            searchPlaceArray.append(sixArray)
        }
        if wordArray.count > 4001 {
            let sevenArray:[Translate]! = Array(wordArray[21001...26000])
            searchPlaceArray.append(sevenArray)
        }
        if wordArray.count > 4001 {
            let eightArray:[Translate]! = Array(wordArray[26001...31000])
            searchPlaceArray.append(eightArray)
        }
        if wordArray.count > 4001 {
            let nineArray:[Translate]! = Array(wordArray[31001...36000])
            searchPlaceArray.append(nineArray)
        }
        if wordArray.count > 4001 {
            let tenArray:[Translate]! = Array(wordArray[36001...(wordArray.count - 1)])
            searchPlaceArray.append(tenArray)
        }
        
        
        tableView.reloadData()
        LoadingOverlay.shared.hideOverlayView()
    }
    
    func updateWordHistory(wordId:String) {
        guard let currentWord = Translate.mr_find(byAttribute: "id", withValue: wordId)?.first as? Translate else { return }
        
        MagicalRecord.save({ localContext in
            currentWord.isSearch = "1"
            
        })
    }
    
    func addFlashCard() {
        let flash_card = FlashCard.mr_find(byAttribute: "id", withValue: "flashcard")
        if flash_card == nil {
            MagicalRecord.save({context in
                let wordData = FlashCard.mr_createEntity(in:context)
                wordData?.id = "flashcard"
                wordData?.title = "Flash card của tôi"
            }, completion: {didContext in
                print("da luu thanh cong title flash card")
                
            })
        }
        
        let word = FlashCard.mr_find(byAttribute: "id", withValue: "word")
        if word == nil {
            MagicalRecord.save({context in
                let wordData = FlashCard.mr_createEntity(in:context)
                wordData?.id = "flashcard"
                wordData?.title = "Từ đã lưu"
            }, completion: {didContext in
                print("da luu thanh cong tu")
            })
        }
        
    }
    
    func reloadWhenHasResult(searchString:String) {
            if(self.filterArray.count == 0 || searchString == "") {
                self.tableView.isHidden = true
                self.notFoundView.isHidden = false
                self.searchActive = false;
            } else {
                self.notFoundView.isHidden = true
                self.tableView.isHidden = false
                self.searchActive = true;
            }
            self.tableView.reloadData()
        
    }
    
    func searchWordFromSearchBar(searchBar: UISearchBar,searchText: String) {
        
        oldSearchString = searchText
        var index:Int = 0
            while  index < 10 {
                let searchString = searchText.lowercased()
                if self.wordArray.count > 0 && self.searchPlaceArray.count > index{
                    if self.changeLangueButton.isSelected {
                        //Viet -> Nhat
                        self.filterArray = self.searchPlaceArray[index].filter({ (object : Translate) -> Bool in
                            
                            if (object.word != nil) && (object.meaning_name != nil) {
                                let categoryMatch = (object.word?.lowercased().hasPrefix(searchString))! || (object.meaning_name?.lowercased().hasPrefix(searchString))!
                                return categoryMatch
                            } else if (object.word != nil) {
                                //                    print("word" + object.word!)
                                let categoryMatch = (object.word?.lowercased().hasPrefix(searchString))
                                return categoryMatch!
                            } else if (object.meaning_name != nil) {
                                let categoryMatch = (object.meaning_name?.lowercased().hasPrefix(searchString))
                                return categoryMatch!
                            } else {
                                return false
                            }
                        } )
                    } else {
                        self.filterArray = self.searchPlaceArray[index].filter({ (object : Translate) -> Bool in
                            if object.romaji != nil {
                                let categoryMatch = (object.romaji?.lowercased().hasPrefix(searchString))
                                return categoryMatch!
                            }else if (object.word != nil) && (object.romaji != nil) && (object.kana != nil)  {
                                let categoryMatch = (object.word?.lowercased().hasPrefix(searchString))! || (object.romaji?.lowercased().hasPrefix(searchString))! || (object.kana?.lowercased().hasPrefix(searchString))!
                                return categoryMatch
                            } else if (object.word != nil) && (object.kana != nil) {
                                //                    print("word" + object.word!)
                                let categoryMatch = (object.word?.lowercased().hasPrefix(searchString))! || (object.kana?.lowercased().hasPrefix(searchString))!
                                return categoryMatch
                            } else if (object.romaji != nil) && (object.word != nil) {
                                let categoryMatch = (object.romaji?.lowercased().hasPrefix(searchString))! || (object.word?.lowercased().hasPrefix(searchString))!
                                return categoryMatch
                            } else if object.kana?.lowercased() != nil && object.romaji?.lowercased() != nil{
                                let categoryMatch = (object.kana?.lowercased().hasPrefix(searchString))! || (object.romaji?.lowercased().hasPrefix(searchString))!
                                return categoryMatch
                            } else if object.word != nil{
                                let categoryMatch = (object.word?.lowercased().hasPrefix(searchString))
                                return categoryMatch!
                            } else if object.kana != nil{
                                let categoryMatch = (object.kana?.lowercased().hasPrefix(searchString))
                                return categoryMatch!
                            } else {
                                return false
                            }
                        } )
                        //Nhat - > Viet
                    }
                }
                self.oldSearchString = ""
                print("so phan tu search duoc \(filterArray.count)")
                if self.filterArray.count > 2  {
                    index = 10
                    if searchText == searchBar.text{
                        DispatchQueue.main.async {
                            if(self.filterArray.count == 0 || searchString == "") {
                                self.tableView.isHidden = true
                                self.notFoundView.isHidden = false
                                self.searchActive = false;
                            } else {
                                self.notFoundView.isHidden = true
                                self.tableView.isHidden = false
                                self.searchActive = true;
                            }
                            let arr: [Translate]! = self.filterArray
                            self.filterArray.removeAll()
                            self.filterArray = arr
                            self.tableView.reloadData()
                        }
                        
                    } else {
                        return
                    }
                } else {
                    if searchText == searchBar.text {
                        index += 1
                    } else {
                        return
                    }
                }
                if index == 10 && filterArray.count == 0 {
                    DispatchQueue.main.async {
                        self.tableView.isHidden = true
                        self.notFoundView.isHidden = false
                        self.searchActive = false;
                        self.introduceView.isHidden = true
                    }
                }
            }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if oldSearchString == "" {
            DispatchQueue.global().async {
                self.searchWordFromSearchBar(searchBar: searchBar, searchText: searchText)
            }
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: {
                self.searchWordFromSearchBar(searchBar: searchBar, searchText: searchText)
            })
        }
    }
    
}
