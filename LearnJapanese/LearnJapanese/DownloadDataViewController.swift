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
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.backgroundColor = UIColor.white
        progressView.frame = CGRect.init(x: 0, y: 0, width: 0, height: fullTrackView.frame.height)
        fullTrackView.addSubview(progressView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "version") == nil {
            self.createDefaultData()
            UserDefaults.standard.set("", forKey: "version")
        } else {
            if ProjectCommon.connectedToNetwork() {
                self.getdataLocal()
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("will disappear download")
    }
    
    func createDefaultData() -> Void {
        if let filepath = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                timer = Timer.scheduledTimer(timeInterval: TimeInterval.init(0.05), target: self, selector: #selector(checkProgress), userInfo: nil, repeats: true)
                let contents = try String(contentsOfFile: filepath)
                let data = contents.data(using:.utf8)
                guard let json = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:AnyObject] else {
                    return
                }
                print("json:", json)
                UserDefaults.standard.set(json["Version"] as! String, forKey: "version")
                
                if let data = json["Data"] as? [[String:AnyObject]] {

                        MagicalRecord.save({ (localContext) in
                            for i in 0 ..< data.count {
                                let word = data[i]
                            let wordData = Translate.mr_createEntity(in: localContext)
                            
                            if let word_id = word["Id"] {
                                wordData?.id = String(describing: word_id)
                            }
                            if let Word = word["Word"] {
                                wordData?.word = Word as? String
                            }
                            
                            if let kana = word["Kana"] {
                                wordData?.kana = kana as? String
                            }
                                if wordData?.id == String(337) {
                                print("romaji" + (word["Word"] as? String)!)
                                }
                            if let Romaji = word["Romaji"] {
                                wordData?.romaji = Romaji as? String
                            }
                            if let SoundUrl = word["SoundUrl"] {
                                wordData?.sound_url = SoundUrl as? String
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
                            
                            }
                            
                        }, completion: {(contextDidSave,error) in
                            //            print("saving is successful")
                            
                            self.performSegue(withIdentifier: "finishLoadingData", sender: nil)
                            
                        })
                }

            } catch {
                // contents could not be loaded
            }
        } else {
        }
    }
    
    func getdataLocal() {
        let parameter = ["secretkey":"nfvsMof10XnUdQEWuxgAZta","action":"get_word_data","version":(UserDefaults.standard.object(forKey: "version") as! String)]
        let urlRequest = "http://api-app.dekiru.vn/DekiruApi.ashx"
        APIManager.sharedInstance.postDataToURL(url:urlRequest, parameters: parameter, onCompletion: {response in
            //            let version = UserDefaults.standard.object(forKey: "version") as! String
            
            self.saveDataToDatabase(response: response)
        })
    }
    
    func saveDataToDatabase(response : DataResponse<Any>) {
                DispatchQueue.main.async {
        
        ///Thành Lã: 2017/01/05
        guard let value = response.result.value as? [String:AnyObject] else { return }
        
        guard response.result.error == nil,
            response.result.isSuccess,
            let data = value["Data"], data.count > 0,
            let dictionaryArray = data as? [[String : AnyObject]] else {
                
                ProjectCommon.initAlertView(
                    viewController: self,
                    title: "",
                    message: "Chưa có phiên bản mới",
                    buttonArray: ["Đồng ý"],
                    onCompletion: { _ in
                        self.performSegue(withIdentifier: "finishLoadingData", sender: nil)
//                        DispatchQueue.main.async {
//                            self.performSegue(withIdentifier: "finishLoadingData", sender: nil)
//                        }
                })
                
                return
        }
        
        
        UserDefaults.standard.set(value["Version"] as! String, forKey: "version")
        DispatchQueue.main.async {
            
            guard let data = response.data else { return }
            
            self.totalDouble = Float(data.count) / 1048576.0
            self.totalLabel.text = "/" + String(format: "%.2f", self.totalDouble ) + " MB"
            self.downloadedLabel.text = "0 MB"
        }
        
        
        MagicalRecord.save({ (localContext) in
            
            dictionaryArray.forEach { word in
                
                let wordData = Translate.mr_createEntity(in: localContext)
                
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
                    self.checkConnectServer()
            }
            
        }, completion: {(contextDidSave,error) in
//            print("saving is successful")
            
            self.performSegue(withIdentifier: "finishLoadingData", sender: nil)
            
        })
        
            }
    }
    
    func checkProgress() {
//            self.currentDouble += self.totalDouble/4300
            let percent = self.progressView.frame.width/self.fullTrackView.frame.size.width * 100
            if percent < 100{
                self.progressView.frame = CGRect.init(x: 0, y: 0, width: self.progressView.frame.size.width + self.fullTrackView.frame.size.width/100, height: self.progressView.frame.height)
                self.downloadedLabel.text = String(format: "%.2f", 16.9) + " MB"
                self.percentDownloadedLabel.text = String(format: "%.2f", self.progressView.frame.width/self.fullTrackView.frame.size.width * 100) + " %"
            } else {
//
            }
    }
    
    func checkConnectServer() {
        DispatchQueue.main.async {
            
            self.currentDouble += self.totalDouble/40737
            let percent = self.currentDouble/self.totalDouble * 100
            if percent < 100{
                self.progressView.frame = CGRect.init(x: 0, y: 0, width: self.progressView.frame.size.width + self.fullTrackView.frame.size.width/40737, height: self.progressView.frame.height)
                self.downloadedLabel.text = String(format: "%.2f", self.currentDouble) + " MB"
                self.percentDownloadedLabel.text = String(format: "%.2f", percent) + " %"
            } else {
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
