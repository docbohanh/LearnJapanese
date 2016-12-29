//
//  NSVTabBarController.swift
//  NSVTabbar-Swift
//
//  Created by srinivas on 7/18/16.
//  Copyright © 2016 Microexcel. All rights reserved.
//

import UIKit
import Alamofire
import MagicalRecord


class NSVTabBarController: UITabBarController , UITabBarControllerDelegate{
    
    var selectedAnimation : NSInteger = NSAnimation_FILP_LEFT

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        //Exchange
        let dictionary = UIStoryboard.init(name: "SearchDekiru", bundle: nil)
        let dictionaryViewController = dictionary.instantiateViewController(withIdentifier: "DictionaryNavigation") as! UINavigationController
        
        //Report
        let historyStoryboard = UIStoryboard.init(name: "History", bundle: nil)
        let historyViewController = historyStoryboard.instantiateViewController(withIdentifier: "HistoryViewController") as! UINavigationController
        
        
        //Schedule
        let documentStoryBoard = UIStoryboard.init(name: "Translate", bundle: nil)
        let documentViewController = documentStoryBoard.instantiateViewController(withIdentifier: "DocumentNavigation") as! UINavigationController
        
        // Other
        let libraryStoryboard = UIStoryboard.init(name: "Library", bundle: nil)
        let libraryViewController = libraryStoryboard.instantiateViewController(withIdentifier: "LibraryNavigation") as! UINavigationController
        
        self.viewControllers = [dictionaryViewController,historyViewController, documentViewController, libraryViewController]
        // Do any additional setup after loading the view.
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
                }, completion: { contextDidSave in
                    //saving is successful
                })
            }
            //reload TableView
        } else {
            print("can't get word")
        }
    }

    
    override func viewDidLayoutSubviews() {
        let imagesArray : NSArray = ["icon_dict","icon_history","icon_document","icon_menu",]
        // To Create the TabBar icons as NSArray for selection time
        
        let  selecteimgArray:NSArray = ["icon_dict_enable","icon_history_enable","icon_document_active","icon_menu_enable"]
        // Customize the tabBar images
        
        //*****//*****//*****//*****//*****//*****//*****//*****//
        
        //****// TabBar Title Customization //*****//
        
        // To Create the attribute dictionary for title for color and font
        NSVBarController.setTabbar(self.tabBar, images:imagesArray, selectedImages: selecteimgArray)
        // Customize the tabBar title
        let attributes = [NSForegroundColorAttributeName:UIColor.lightGray]
        NSVBarController.setTabBarTitleColor(attributes as AnyObject)
        //*****//*****//*****//*****//*****//*****//*****//*****//
        let attributesSelected = [NSForegroundColorAttributeName:COMMON_COLOR]
        NSVBarController.setTabBarTitleColorSelected(attributesSelected as AnyObject)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         //****// TabBar Images Animations //*****//
//         NSVBarController.setAnimation(tabBarController, animationtype:selectedAnimation)
        //*****//*****//*****//*****//*****//*****//*****//*****//

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func buttonsTouched(_ sender:UIButton){
        selectedAnimation = sender.tag ;
    }

}
