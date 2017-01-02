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
    var isFinished:Bool = false
    var progressTimer: Timer!
    var wordArray = [Translate]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.backgroundColor = UIColor.white
        progressView.frame = CGRect.init(x: 0, y: 0, width: 0, height: fullTrackView.frame.height)
        fullTrackView.addSubview(progressView)
        if UserDefaults.standard.object(forKey: "version") == nil {
            UserDefaults.standard.set("", forKey: "version")
        } else {

        }
//        DispatchQueue.global().async {
            self.getdataLocal()
//        }
        // Do any additional setup after loading the view.
    }

    func getdataLocal() {
        let parameter = ["secretkey":"nfvsMof10XnUdQEWuxgAZta","action":"get_word_data","version":(UserDefaults.standard.object(forKey: "version") as! String)]
        let urlRequest = "http://app-api.dekiru.vn/DekiruApi.ashx"
        APIManager.sharedInstance.postDataToURL(url:urlRequest, parameters: parameter, onCompletion: {response in
            let version = UserDefaults.standard.object(forKey: "version") as! String
                self.saveDataToDatabase(response: response)
        })
    }
    
    func saveDataToDatabase(response : DataResponse<Any>) {
        DispatchQueue.main.async {
            
        if response.result.value != nil {
        let value = response.result.value as! [String:AnyObject]
        
        if response.result.error == nil && response.result.isSuccess && (value["Data"]?.count)! > 0 {
            UserDefaults.standard.set(value["Version"] as! String, forKey: "version")
            DispatchQueue.main.async {
                if response.data != nil {
                    self.totalDouble = Float((response.data?.count)!)/1048576.0
                    self.totalLabel.text = "/" + String(format: "%.2f",self.totalDouble ) + " MB"
                     self.downloadedLabel.text = "0 MB"
                }
            }
            let resultDictionary = response.result.value! as! [String:AnyObject]
            let dictionaryArray = resultDictionary["Data"] as! [[String : AnyObject]]
            for index in 0..<dictionaryArray.count {

            let localContext = NSManagedObjectContext.mr_default()
            localContext.mr_save({localContext in
                        let word = dictionaryArray[index]
                    
                        let wordData = Translate.mr_createEntity()
                        if let word_id = word["Id"] {
                            wordData?.id = String(describing: word_id)
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
                        
                        let meaningWord = word["Meaning"] as? [[String:AnyObject]]
                        let first = meaningWord?.first
                        if let Meaning  = first?["Meaning"] {
                            wordData?.meaning_name = Meaning as? String
                        }
                        if let MeaningId = first?["MeaningId"] {
                            wordData?.meaningId = MeaningId as? String
                        }
                        if let Type = first?["Type"] {
                            wordData?.meaning_type = String(describing: Type)
                        }
                        
                        let exampleWord = word["Example"] as? [[String:AnyObject]]
                        let firstExample = exampleWord?.first

                        if let ExampleId = firstExample?["ExampleId"] {
                            wordData?.example_id = String(describing: ExampleId)
                        }
                        if let Example = firstExample?["Example"] {
                            wordData?.example_name = Example as? String
                        }
                        if let Meaning = firstExample?["Meaning"] {
                            wordData?.example_meaning_name = Meaning as? String
                        }
                        if let MeaningId = firstExample?["MeaningId"] {
                            wordData?.example_meaning_id = String(describing: MeaningId)
                        }
                        if let Romaji = firstExample?["Romaji"] {
                            wordData?.example_romaji = Romaji as? String
                        }
                        if let Kana = firstExample?["Kana"] {
                            wordData?.example_kana = Kana as? String
                        }
                        if let SoundUrl = firstExample?["SoundUrl"] {
                            wordData?.example_sound_url = SoundUrl as? String
                        }
                    self.appDelegate.wordArray.append(wordData!)
                        self.checkProgress()
                        print("Dang luu du lieu ")
                    
                    print("Dang luu du lieu ")

                
            }, completion: { contextDidSave in
                //saving is successful
                print("saving is successful")
            })
            }
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
    }
    }

    func checkProgress() {
        DispatchQueue.main.async {
            var isPerformSegue:Bool = false
            self.currentDouble += self.totalDouble/40737
            let percent = self.currentDouble/self.totalDouble * 100
            if percent < 100{
                self.progressView.frame = CGRect.init(x: 0, y: 0, width: self.progressView.frame.size.width + self.fullTrackView.frame.size.width/40737, height: self.progressView.frame.height)
                self.downloadedLabel.text = String(format: "%.2f", self.currentDouble) + " MB"
                self.percentDownloadedLabel.text = String(format: "%.2f", percent) + " %"
            } else {
                let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let tabBarViewController = mainStoryboard.instantiateViewController(withIdentifier: "NSVTabBarController") as! NSVTabBarController

                self.present(tabBarViewController, animated: true, completion: nil)
//                if !isPerformSegue {
//                    self.performSegue(withIdentifier: "finishLoadingData", sender: nil)
//                    isPerformSegue = true
//                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
