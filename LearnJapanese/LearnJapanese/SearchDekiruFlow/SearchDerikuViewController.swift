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

class SearchDerikuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
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
    var searchWordArray = [Translate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView .register(UINib.init(nibName: "WordSearchTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "WordSearchTableViewCell")
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        popupView = Bundle.main.loadNibNamed("SavePopupView", owner: self, options: nil)?.first as! SavePopupView
        self.getWordFromDatabase()
    }

    override func viewDidLayoutSubviews() {
        searchBarView.layer.cornerRadius = 5
        searchBarView.layer.borderWidth = 1
        searchBarView.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
    
    @IBAction func deleteSearchButton_clicked(_ sender: Any) {
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
        return searchWordArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let strIdentifer = "WordSearchTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: strIdentifer, for: indexPath) as! WordSearchTableViewCell
        if let word : Translate = searchWordArray[indexPath.row] {
            cell.wordLabel.text = word.word
            cell.contentLabel.text = word.meaning_name
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
            DispatchQueue.global().async {
                self.searchWord(text: textField.text!)
            }
        }

        textField.resignFirstResponder()
        return true
    }
    
    func getWordFromDatabase() {
        DispatchQueue.global().async {
            let localContext = NSManagedObjectContext.mr_default()
            self.wordArray = Translate.mr_findAll(in: localContext) as! [Translate]
        }
    }
    
    func searchWord(text:String) {
        for word in wordArray {
            
            if (word.word?.hasPrefix(text))! {
                searchWordArray.append(word)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
