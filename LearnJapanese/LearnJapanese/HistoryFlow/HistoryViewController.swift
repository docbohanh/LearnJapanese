//
//  HistoryViewController.swift
//  LearnJapanese
//
//  Created by Thuy Phan on 11/29/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
