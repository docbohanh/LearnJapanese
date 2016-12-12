//
//  NSVTabBarController.swift
//  NSVTabbar-Swift
//
//  Created by srinivas on 7/18/16.
//  Copyright © 2016 Microexcel. All rights reserved.
//

import UIKit


class NSVTabBarController: UITabBarController , UITabBarControllerDelegate{
    
    var selectedAnimation : NSInteger = NSAnimation_FILP_LEFT

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
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
