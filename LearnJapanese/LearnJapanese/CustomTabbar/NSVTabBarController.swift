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
        print("nsvTabbar")
        self.delegate = self
        print("SearchDekiru")
        //Exchange
        let dictionary = UIStoryboard.init(name: "SearchDekiru", bundle: nil)
        let dictionaryViewController = dictionary.instantiateViewController(withIdentifier: "DictionaryNavigation") as! UINavigationController
        print("History")
        //Report
        let historyStoryboard = UIStoryboard.init(name: "History", bundle: nil)
        let historyViewController = historyStoryboard.instantiateViewController(withIdentifier: "HistoryViewController") as! UINavigationController
        
        print("Translate")
        //Schedule
        let documentStoryBoard = UIStoryboard.init(name: "Translate", bundle: nil)
        let documentViewController = documentStoryBoard.instantiateViewController(withIdentifier: "DocumentNavigation") as! UINavigationController
        print("Library")
        // Other
        let libraryStoryboard = UIStoryboard.init(name: "Library", bundle: nil)
        let libraryViewController = libraryStoryboard.instantiateViewController(withIdentifier: "LibraryNavigation") as! UINavigationController
        
        self.viewControllers = [dictionaryViewController,historyViewController, documentViewController, libraryViewController]
        // Do any additional setup after loading the view.

        
    }
    
    override func viewDidLayoutSubviews() {
        let imagesArray : NSArray = ["icon_dict","icon_history","icon_document","icon_menu",]
        // To Create the TabBar icons as NSArray for selection time
        
        let  selecteimgArray:NSArray = ["dict-hover","history-hover","transalate-hover","more-hover"]
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
