//
//  SearchDerikuViewController.swift
//  LearnJapanese
//
//  Created by Thuy Phan on 11/29/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import MagicalRecord

class SearchDerikuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
    
    var arrayWord = NSMutableArray.init()
    
    
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
        let parameter = ["secretkey":"nfvsMof10XnUdQEWuxgAZta","action":"get_word_data","version":"0"]
        let urlRequest = "http://app-api.dekiru.vn/DekiruApi.ashx"
        APIManager.sharedInstance.postDataToURL(url:urlRequest, parameters: parameter, onCompletion: {response in
                if response.result.error == nil && response.result.isSuccess && response.result.value != nil{
                    let resultDictionary = response.result.value! as! [String:AnyObject]
                    let dictionaryArray = resultDictionary["Data"] as! [[String : AnyObject]]
                    
                    for word in dictionaryArray {
                        MagicalRecord.saveWithBlock({( localContext) in
                            var wordData = Translate.MR_findFirstByAttribute("id", withValue: word["clubId"]!, inContext: localContext)
                            if wordData == nil {
                                wordData = Ranking.MR_createEntityInContext(localContext)
                                wordData.id = word["Id"] as! String?
                                wordData.kana = word["kana"] as! String
                                wordData.romaji = word["Romaji"] as! String
                                wordData.sound_url = word["SoundUrl"] as! String
                            }
                            rankObject?.name = dictTeamRank["name"]
                        }){ (contextDidSave: Bool, error: NSError?) in
                            self.comple
                        }
                        
                    }
                    //reload TableView
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                            
                }
            })

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
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let strIdentifer = "WordSearchTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: strIdentifer, for: indexPath) as! WordSearchTableViewCell
        cell.initCell(wordModel: WordModel())
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchDerikuStoryboard = UIStoryboard.init(name: "SearchDekiru", bundle: Bundle.main)
        let detaiVC = searchDerikuStoryboard.instantiateViewController(withIdentifier: "WordDetailViewController") as! WordDetailViewController
        self.navigationController?.pushViewController(detaiVC, animated: true)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
