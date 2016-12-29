//
//  AppDelegate.swift
//  LearnJapanese
//
//  Created by Nguyen Hai Dang on 11/29/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        MagicalRecord.setupCoreDataStack(withStoreNamed: "learningJapanese.sqlite")
        DispatchQueue.global().async {
            self.getFlashCard()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    /**
     Get Flash card
     */
    func getFlashCard() {
        let parameter = ["secretkey":"nfvsMof10XnUdQEWuxgAZta","action":"get_flash_cart","pageindex":"1","pagesize":"300"]
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
            for flashCardObject in dictionaryArray {
                let localContext = NSManagedObjectContext.mr_default()
                let flashCard = FlashCard.mr_createEntity(in: localContext)
                localContext.mr_save({localContext in
                    if let flash_id = flashCardObject["Id"] {
                        flashCard?.id = flash_id as? String
                    }
                    if let Title = flashCardObject["Title"] {
                        flashCard?.title = Title as? String
                    }
                    
                    if let Avatar = flashCardObject["Avatar"] {
                        flashCard?.avatar = Avatar as? String
                    }
                })
            }
        }
    }
}

