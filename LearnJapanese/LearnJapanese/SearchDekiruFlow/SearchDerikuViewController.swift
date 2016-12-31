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
    var wordArray = [Translate]()
    var firstArray = [Translate]()
    var secondArray = [Translate]()
    var searchWordArray = [Translate]()
    var filterArray = [Translate]()
    var searchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView .register(UINib.init(nibName: "WordSearchTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "WordSearchTableViewCell")
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        popupView = Bundle.main.loadNibNamed("SavePopupView", owner: self, options: nil)?.first as! SavePopupView
        self.getWordFromDatabase()
    }

    override func viewDidLayoutSubviews() {
//        searchBarView.layer.cornerRadius = 5
//        searchBarView.layer.borderWidth = 1
//        searchBarView.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tappedAddNewWord(_ sender: UIButton) {
    }
    
    @IBAction func tappedChangedLangue(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        searchBar.reloadInputViews()
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
            return filterArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let strIdentifer = "WordSearchTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: strIdentifer, for: indexPath) as! WordSearchTableViewCell
        if searchActive {
            if let word : Translate = filterArray[indexPath.row] {
                if changeLangueButton.isSelected {
                    cell.wordLabel.text = word.meaning_name
                    cell.contentLabel.text = word.word
                } else {
                    cell.wordLabel.text = word.word
                    cell.contentLabel.text = word.meaning_name
                }
            }
        }else {
            if let word : Translate = firstArray[indexPath.row] {
                if changeLangueButton.isSelected {
                    cell.wordLabel.text = word.meaning_name
                    cell.contentLabel.text = word.word
                } else {
                    cell.wordLabel.text = word.word
                    cell.contentLabel.text = word.meaning_name
                }
            }
        }
        
        cell.initCell(wordModel: WordModel())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchDerikuStoryboard = UIStoryboard.init(name: "SearchDekiru", bundle: Bundle.main)
        let detaiVC = searchDerikuStoryboard.instantiateViewController(withIdentifier: "WordDetailViewController") as! WordDetailViewController
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
            wordDetailViewController?.searchText = searchTextfield.text
        }
    }
    func getWordFromDatabase() {
        DispatchQueue.global().async {
            self.wordArray = Translate.mr_findAll() as! [Translate]
            self.firstArray.removeAll()
            for index in 0..<10000 {
                if self.wordArray.count > 500 {
                    self.firstArray.append(self.wordArray[index])
                }
            }

            print("So tu moi" + String(self.wordArray.count))
        }
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchText.lowercased()
        if changeLangueButton.isSelected {
            if wordArray.count > 0 {
                filterArray = wordArray.filter({ (object : Translate) -> Bool in
                    if object.word != nil && object.meaning_name != nil  {
                        let categoryMatch = (object.word?.lowercased().contains(searchString))! || (object.meaning_name?.lowercased().contains(searchString))!
                        return categoryMatch
                    } else if object.word != nil{
                        print("word" + object.word!)
                        let categoryMatch = (object.word?.lowercased().contains(searchString))!
                        return categoryMatch
                    } else if object.meaning_name != nil{
                        let categoryMatch = (object.romaji?.lowercased().contains(searchString))!
                        return categoryMatch
                    } else {
                        return false
                    }
                })
            }

        } else {
            if firstArray.count > 0 {
                filterArray = firstArray.filter({ (object : Translate) -> Bool in
                    if object.word != nil && object.kana != nil  {
                        let categoryMatch = (object.word?.lowercased().contains(searchString))! || (object.kana?.lowercased().contains(searchString))!
                        return categoryMatch
                    } else if object.kana != nil{
                        let categoryMatch = (object.kana?.lowercased().contains(searchString))!
                        return categoryMatch
                    } else if object.word != nil {
                        let categoryMatch = (object.word?.lowercased().contains(searchString))!
                        return categoryMatch
                    } else {
                        return false
                    }
                    
                    
                })
            }

        }
        
        if(filterArray.count == 0 || searchString == ""){
            tableView.isHidden = true
            notFoundView.isHidden = false
            searchActive = false;
        } else {
            notFoundView.isHidden = true
            tableView.isHidden = false
            searchActive = true;
        }
        tableView.isHidden = false
        tableView.reloadData()
    }
}
