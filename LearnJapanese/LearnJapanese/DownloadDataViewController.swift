//
//  DownloadDataViewController.swift
//  LearnJapanese
//
//  Created by Nguyen Hai Dang on 12/29/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import MagicalRecord
import Alamofire

class DownloadDataViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var downloadView: UIView!
    @IBOutlet weak var titleLoadingLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var downloadedLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var fullTrackView: UIView!
    @IBOutlet weak var percentDownloadedLabel: UILabel!
    
    var progressView = UIView()
    var totalDouble = Float()
    var currentDouble: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.backgroundColor = UIColor.white
        progressView.frame = CGRect.init(x: 0, y: 0, width: 0, height: fullTrackView.frame.height)
        fullTrackView.addSubview(progressView)
        if UserDefaults.standard.object(forKey: "version") == nil {
            UserDefaults.standard.set(1.0, forKey: "version")
        } else {

        }
        DispatchQueue.global().async {
            self.getdataLocal()
        }
        // Do any additional setup after loading the view.
    }

    func getdataLocal() {
        let parameter = ["secretkey":"nfvsMof10XnUdQEWuxgAZta","action":"get_word_data","version":String(format: "%.1f",UserDefaults.standard.object(forKey: "version") as! Float)]
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
        let value = response.result.value as! [String:AnyObject]
        
        if response.result.error == nil && response.result.isSuccess && (value["Data"]?.count)! > 0{
            DispatchQueue.main.async {
                var version:Float = UserDefaults.standard.object(forKey: "version") as! Float
                version += 0.1
                UserDefaults.standard.set(version, forKey: "version")
                if response.data != nil {
                    self.totalDouble = Float((response.data?.count)!)/1048576.0
                    self.totalLabel.text = "/" + String(format: "%.2f",self.totalDouble ) + " MB"
                     self.downloadedLabel.text = "0 MB"
                }
            }
            let resultDictionary = response.result.value! as! [String:AnyObject]
            let dictionaryArray = resultDictionary["Data"] as! [[String : AnyObject]]
            let localContext = NSManagedObjectContext.mr_default()

            localContext.mr_save({localContext in
                for index in 0..<dictionaryArray.count {
                    let word = dictionaryArray[index]
                    var wordData = Translate.mr_findFirst(byAttribute: "id", withValue: word["Id"]!, in: localContext)
                    if wordData == nil {
                        wordData = Translate.mr_createEntity(in: localContext)
                    }
                    if let word_id = word["Id"] {
                        wordData?.id = word_id as? String
                    }
                    if let Word = word["Word"] {
                        wordData?.word = Word as? String
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
                        wordData?.modified = Modified as? String
                    }
                    if let SoundUrl = word["SoundUrl"] {
                        wordData?.sound_url = SoundUrl as? String
                    }
                    if let Avatar = word["Avatar"] {
                        wordData?.avatar = Avatar as? String
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
                    DispatchQueue.main.async {
                        self.progressView.frame = CGRect.init(x: 0, y: 0, width: self.progressView.frame.size.width + self.fullTrackView.frame.size.width/40737, height: self.progressView.frame.height)
                        self.currentDouble += self.totalDouble/40737
                        self.downloadedLabel.text = String(format: "%.2f", self.currentDouble) + " MB"
                        let percent = self.currentDouble/self.totalDouble * 100
                        self.percentDownloadedLabel.text = String(format: "%.2f", percent) + " %"
                    }
                    }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "finishLoadingData", sender: nil)
                }
                }, completion: { contextDidSave in
                    //saving is successful
                    print("saving is successful")
                })
            
            //reload TableView
        } else {
            ProjectCommon.initAlertView(viewController: self, title: "", message: "Không có phiên bản mới", buttonArray: ["Cancel"], onCompletion: {_ in
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "finishLoadingData", sender: nil)
                }
            })
            print("can't get word")
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
