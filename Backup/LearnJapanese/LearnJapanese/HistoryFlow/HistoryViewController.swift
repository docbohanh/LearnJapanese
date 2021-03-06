//
//  HistoryViewController.swift
//  LearnJapanese
//
//  Created by Thuy Phan on 11/29/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import MagicalRecord

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,HistorySearchDelegate {

    @IBOutlet weak var tableView: UITableView!
    var historyArray: [History]!
    
    @IBOutlet weak var changeLangueButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView .register(UINib.init(nibName: "WordSearchTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "WordSearchTableViewCell")
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.historyArray = History.mr_findAll() as! [History]
        self.tableView.reloadData()
    }
    @IBAction func tappedChangeLangue(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* =============== TABLEVIEW DATASOURCE =============== */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return arrayWord.count
        return historyArray != nil ? historyArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let strIdentifer = "WordSearchTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: strIdentifer, for: indexPath) as! WordSearchTableViewCell
        cell.delegate = self
        cell.deleteButton.tag = 690 + indexPath.row
        cell.initHistoryCell(wordModel: WordModel())
        if historyArray.count > indexPath.row {
            let history = historyArray[indexPath.row]
            if changeLangueButton.isSelected {
                cell.wordLabel.text = history.meaning_name
                cell.contentLabel.text = history.word
            } else {
                cell.wordLabel.text = history.word
                cell.contentLabel.text = history.meaning_name
            }
        }

        return cell
        
    }
        

    func deleteWord(historyWord: History, atIndex: Int) {
        let historyObject = historyArray[atIndex]
        historyArray.remove(at: atIndex)
        tableView.reloadData()
        
        let localContext = NSManagedObjectContext.mr_default()
        historyObject.mr_deleteEntity(in: localContext)
        localContext.mr_saveToPersistentStoreAndWait()
    }
}
