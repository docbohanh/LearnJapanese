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
        DispatchQueue.global().async {
            self.getdataLocal()
        }
    }

    func getdataLocal() {
        let parameter = ["secretkey":"nfvsMof10XnUdQEWuxgAZta","action":"get_word_data","version":"1.0"]
        let urlRequest = "http://app-api.dekiru.vn/DekiruApi.ashx"
        APIManager.sharedInstance.postDataToURL(url:urlRequest, parameters: parameter, onCompletion: {response in
                if Thread.isMainThread {
                    DispatchQueue.global().async {
                    self.saveDataToDatabase(response: response)
                    }
                } else {
                    self.saveDataToDatabase(response: response)
                    }
                })
    }
    
    func saveDataToDatabase(response : DataResponse<Any>) {
        if response.result.error == nil && response.result.isSuccess && response.result.value != nil{
            let resultDictionary = response.result.value! as! [String:AnyObject]
            let dictionaryArray = resultDictionary["Data"] as! [[String : AnyObject]]
            
            for word in dictionaryArray {
                let localContext = NSManagedObjectContext.mr_default()
                var wordData = Translate.mr_findFirst(byAttribute: "id", withValue: word["Id"]!, in: localContext)
                
                localContext.mr_save({localContext in
                    if wordData == nil {
                        wordData = Translate.mr_createEntity(in: localContext)
                    }
                    if let word_id = word["Id"] {
                        wordData?.id = word_id as? String
                    }
                    if let kana = word["Kana"] {
                        wordData?.kana = kana as? String
                    }
                    if let Romaji = word["Romaji"] {
                        wordData?.romaji = Romaji["Romaji"] as? String
                    }
                    if let SoundUrl = word["SoundUrl"] {
                        wordData?.sound_url = SoundUrl["SoundUrl"] as? String
                    }
                    if let LastmodifiedDate = word["LastmodifiedDate"] {
                        let trimString = LastmodifiedDate
                        let timeStamp:String = trimString.substring(from: 5)
                        wordData?.last_modified = timeStamp.substring(to: (timeStamp.characters.count - 7))
                    }
                    if let Modified = word["Modified"] {
                        wordData?.word = Modified as? String
                    }
                    if let SoundUrl = word["SoundUrl"] {
                        wordData?.kana = SoundUrl as? String
                    }
                    if let Avatar = word["Avatar"] {
                        wordData?.kana = Avatar as? String
                    }
                    
                    let meaningWord = word["Meaning"] as? [String:AnyObject]
                    if let Meaning  = meaningWord?["Meaning"] {
                        wordData?.meaning_name = Meaning as? String
                    }
                    if let MeaningId = meaningWord?["MeaningId"] {
                        wordData?.meaningId = MeaningId as? String
                    }
                    if let Type = meaningWord?["Type"] {
                        wordData?.meaning_type = String(describing: Type)
                    }
                    
                    let exampleWord = word["Example"] as? [String:AnyObject]
                    if let ExampleId = exampleWord?["ExampleId"] {
                        wordData?.example_id = ExampleId as? String
                    }
                    if let Example = exampleWord?["Example"] {
                        wordData?.example_name = Example as? String
                    }
                    if let Meaning = exampleWord?["Meaning"] {
                        wordData?.example_meaning_name = Meaning as? String
                    }
                    if let MeaningId = exampleWord?["MeaningId"] {
                        wordData?.example_meaning_id = MeaningId as? String
                    }
                    if let Romaji = exampleWord?["Romaji"] {
                        wordData?.example_romaji = Romaji as? String
                    }
                    if let Kana = exampleWord?["Kana"] {
                        wordData?.example_kana = Kana as? String
                    }
                    if let SoundUrl = exampleWord?["SoundUrl"] {
                        wordData?.example_sound_url = SoundUrl as? String
                    }
                    self.wordArray.append(wordData!)
                }, completion: { contextDidSave in
                    //saving is successful
                })
            }
            //reload TableView
        } else {
            print("can't get word")
        }
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
