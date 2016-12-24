//
//  LibraryViewController.swift
//  LearnJapanese
//
//  Created by Nguyen Hai Dang on 11/29/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ShowVocaburaryListDelegate {

    @IBOutlet weak var DetailLibraryButton: UIButton!
    @IBOutlet weak var libraryTableView: UITableView!
    var numberOfSection: Int = 2
    
    var libraryListArray = [["value":["なぜですか","いつですか","どきですか"],"key":"FlashCard của tôi"],["key":"từ đã lưu","value":["なぜですか","いつですか"]],["key":"chủ đề 1","value":["お願いします","どちらですか","始めますて","こ日は"]]]
    var currentLibraryArray = [["value":["なぜですか","いつですか","どきですか"],"key":"FlashCard của tôi"],["key":"từ đã lưu","value":["なぜですか","いつですか"]],["key":"chủ đề 1","value":["お願いします","どちらですか","始めますて","こ日は"]]]
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        for index in 0..<currentLibraryArray.count {
            currentLibraryArray[index].removeValue(forKey: "value")
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tappedAddDetailLibrary(_ sender: UIButton) {
        currentLibraryArray.removeAll()
        currentLibraryArray = libraryListArray
        for index in 0..<currentLibraryArray.count {
            currentLibraryArray[index].removeValue(forKey: "value")
        }
        libraryTableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return currentLibraryArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = Int()
        for index in 0..<currentLibraryArray.count {
            if let value = currentLibraryArray[index]["value"] {
                numberOfRow += 1
            }
        }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VocabularyTableViewCell", for: indexPath) as! VocabularyTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options:[:])?.first as? HeaderView
        headerView?.delegate = self
        headerView?.titleLabel.text = currentLibraryArray[section]["key"] as! String?
        headerView?.backgroundHeaderButton.tag = 500 + section
        return (headerView as? UIView?)!
    }
    
    func tappedShowVocaburaryList(sender: UIButton) {
        currentLibraryArray.removeAll()
        currentLibraryArray.append(libraryListArray[sender.tag - 500])
        libraryTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
