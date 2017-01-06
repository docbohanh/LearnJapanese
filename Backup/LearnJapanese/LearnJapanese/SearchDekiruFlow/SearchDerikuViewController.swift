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
    var secondArray = [Translate]()
    var searchWordArray = [Translate]()
    var filterArray = [Translate]()
    var filterDisplayArray = [Translate]()
    var searchPlaceArray = [[Translate]]()
    var searchResultArray = [[Translate]]()
    
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
        self.getWordFromDatabase()
        self.addFlashCard()
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tappedAddNewWord(_ sender: UIButton) {
    }
    
    @IBAction func tappedChangedLangue(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.searchBar(searchBar, textDidChange: searchBar.text ?? "")
    }
    
    @IBAction func tappedSearchWithGoogle(_ sender: Any) {
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
        return filterDisplayArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let strIdentifer = "WordSearchTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: strIdentifer, for: indexPath) as! WordSearchTableViewCell
        if filterDisplayArray.count > indexPath.row {
            let translate = filterDisplayArray[indexPath.row]
            
            if searchActive {
                
                cell.iconImageView.image = translate.isSearch ? UIImage(named: "icon_history") : UIImage(named: "icon_search")
                
                //            if word.isSearch {
                //                cell.iconImageView.image = UIImage(named: "icon_history")
                //            } else {
                //                cell.iconImageView.image = UIImage(named: "icon_search")
                //
                //            }
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
        }
        cell.initCell(wordModel: WordModel())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchDerikuStoryboard = UIStoryboard.init(name: "SearchDekiru", bundle: Bundle.main)
        let detaiVC = searchDerikuStoryboard.instantiateViewController(withIdentifier: "WordDetailViewController") as! WordDetailViewController
        currentDetailTranslate = filterDisplayArray[indexPath.row]
        detaiVC.detailTranslate = currentDetailTranslate
        detaiVC.searchText = currentDetailTranslate.word ?? ""
        detaiVC.wordId = currentDetailTranslate.id ?? ""
        self.navigationController?.pushViewController(detaiVC, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.characters.count)! > 0 {
            self.introduceView.isHidden = true
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoWordDetail" {
            let wordDetailViewController = segue.destination as? WordDetailViewController
            wordDetailViewController?.searchText = searchTextfield.text!
            wordDetailViewController?.wordId = currentDetailTranslate.id ?? ""
        }
    }
    func getWordFromDatabase() {
        LoadingOverlay.shared.showOverlay(view: self.view)
        tableView.reloadData()
        LoadingOverlay.shared.hideOverlayView()
        DispatchQueue.global().async {
            self.wordArray = Translate.mr_findAll(in: NSManagedObjectContext.mr_default())! as! [Translate]
//            if self.wordArray != nil && self.wordArray.count > 0 {
//                for index in 0..<500 {
//                    if self.wordArray.count > ((self.searchPlaceArray.count * 500) + index)  {
//                        let existNumber = self.searchPlaceArray.count
//                        let array:[Translate] = [self.wordArray![(existNumber * 500) + index]]
//                        self.searchPlaceArray.append(array)
//                    } else {
//                        break
//                    }
//
//                    
//                }
//            }

        }

    }
    
    func updateWordHistory(wordId:String) {
        guard let currentWord = Translate.mr_find(byAttribute: "id", withValue: wordId)?.first as? Translate else { return }
        
        MagicalRecord.save({ localContext in
            currentWord.isSearch = true
            
        })
        
        //        if currentWord != nil {
        //            let localContext = NSManagedObjectContext.mr_default()
        //            MagicalRecord.save({localContext in
        //                currentWord.isSearch = true
        //
        //            })
        //            localContext.mr_saveToPersistentStore(completion: {context in
        //                self.wordArray = Translate.mr_findAll(in: NSManagedObjectContext.mr_default())! as! [Translate]
        //
        //                self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: UITableViewRowAnimation.none)
        //            })
        //        }
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
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        let searchString = searchText.lowercased()
//
//        DispatchQueue.global().async {
//           self.searchWordInArray(firstArray: self.wordArray, searchText: searchText)
//            for index in 0..<30 {
//                if self.filterArray.count > index {
//                    self.filterDisplayArray.append(self.filterArray[index])
//                }
//            }
//            DispatchQueue.main.async {
//                if(self.filterArray.count == 0 || searchString == "") {
//                    self.tableView.isHidden = true
//                    self.notFoundView.isHidden = false
//                    self.searchActive = false;
//                } else {
//                    self.notFoundView.isHidden = true
//                    self.tableView.isHidden = false
//                    self.searchActive = true;
//                    
//                }
//                self.tableView.reloadData()
//            }
//            
//        }
//
//
//
//    }
    
    func searchWordInArray(firstArray:[Translate],searchText:String) {
        let searchString = searchText.lowercased()
        if firstArray.count > 0 {
            if self.changeLangueButton.isSelected {
                //Viet -> Nhat
                self.filterArray = firstArray.filter({ (object : Translate) -> Bool in
                    if (object.word != nil) && (object.meaning_name != nil) {
                        let categoryMatch = (object.word!.lowercased().hasPrefix(searchString.lowercased())) || (object.meaning_name!.lowercased().hasPrefix(searchString.lowercased()))
                        return categoryMatch
                    } else if (object.word != nil) {
                        //                    print("word" + object.word!)
                        let categoryMatch = (object.word!.lowercased().hasPrefix(searchString.lowercased()))
                        return categoryMatch
                    } else if (object.meaning_name != nil) {
                        let categoryMatch = (object.meaning_name!.lowercased().hasPrefix(searchString.lowercased()))
                        return categoryMatch
                    } else {
                        return false
                    }
                } )
                
            } else {
                self.filterArray = firstArray.filter({ (object : Translate) -> Bool in
                    if (object.word != nil) && (object.romaji != nil) && (object.kana != nil)  {
                        let categoryMatch = (object.word!.lowercased().hasPrefix(searchString.lowercased())) || (object.romaji!.lowercased().hasPrefix(searchString.lowercased())) || (object.kana!.lowercased().hasPrefix(searchString.lowercased()))
                        return categoryMatch
                    } else if (object.word != nil) && (object.kana != nil) {
                        //                    print("word" + object.word!)
                        let categoryMatch = (object.word!.lowercased().hasPrefix(searchString.lowercased())) || (object.kana!.lowercased().hasPrefix(searchString.lowercased()))
                        return categoryMatch
                    } else if (object.romaji != nil) && (object.word != nil) {
                        let categoryMatch = (object.romaji!.lowercased().hasPrefix(searchString.lowercased())) || (object.word!.lowercased().hasPrefix(searchString.lowercased()))
                        return categoryMatch
                    } else if object.kana != nil && object.romaji != nil{
                        let categoryMatch = (object.kana!.lowercased().hasPrefix(searchString.lowercased())) || (object.romaji!.lowercased().hasPrefix(searchString.lowercased()))
                        return categoryMatch
                    } else if object.word != nil{
                        let categoryMatch = (object.word!.lowercased().hasPrefix(searchString.lowercased()))
                        return categoryMatch
                    }  else if object.romaji != nil{
                        let categoryMatch = (object.romaji!.lowercased().hasPrefix(searchString.lowercased()))
                        return categoryMatch
                    }  else if object.kana != nil{
                        let categoryMatch = (object.kana!.lowercased().hasPrefix(searchString.lowercased()))
                        return categoryMatch
                    } else {
                        return false
                    }
                } )
                
                //Nhat - > Viet
            }
        }
    }
    
}
