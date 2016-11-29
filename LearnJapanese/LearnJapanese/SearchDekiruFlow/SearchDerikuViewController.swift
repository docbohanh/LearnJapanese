//
//  SearchDerikuViewController.swift
//  LearnJapanese
//
//  Created by Thuy Phan on 11/29/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

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
    
    var arrayWord = NSMutableArray.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView .register(UINib.init(nibName: "WordSearchTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "WordSearchTableViewCell")
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
