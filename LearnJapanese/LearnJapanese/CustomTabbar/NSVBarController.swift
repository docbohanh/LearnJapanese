//
//  NSVBarController.swift
//  NSVTabbar-Swift
//
//  Created by srinivas on 7/18/16.
//  Copyright © 2016 Microexcel. All rights reserved.
//


let NSAnimation_Bounce_Y    = 1
let NSAnimation_Bounce_X    = 2

let NSAnimation_FILP_BOTTOM = 3
let NSAnimation_FILP_TOP    = 4
let NSAnimation_FILP_LEFT   = 5
let NSAnimation_FILP_RIGHT  = 6

let NSAnimation_Cross_Dissolve  = 7
let NSAnimation_Fade            = 8

let NSAnimation_CurlUp      = 9
let NSAnimation_CurlDown    = 10



import UIKit

class NSVBarController: NSVTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
     class func setTabbar(_ tabBar:UITabBar , images:NSArray , selectedImages:NSArray){
        if (images.count != selectedImages.count) {
            NSLog("Tabbar Images and SelectedImages are not equal"); return ;
        }else if (images.count != tabBar.items!.count){
            NSLog("Tabbar Buttons and Images are not equal"); return ;
        }else if (selectedImages.count != tabBar.items!.count){
            NSLog("Tabbar Buttons and SelectedImages are not equal"); return ;
        }
        
        var num: Int = 0
        for  tabBarItem:UITabBarItem in tabBar.items! {
            let normalImage: UIImage! = UIImage(named:images[num] as! String)?.withRenderingMode(.alwaysOriginal)
            let selectedImage: UIImage! = UIImage(named: selectedImages[num] as! String)?.withRenderingMode(.alwaysOriginal)
             tabBarItem.image = normalImage
            tabBarItem.selectedImage =  selectedImage ;
             num += 1
        }
     }
    
    class  func setTabBarTitleColor(_ color:AnyObject){
        UITabBarItem.appearance().setTitleTextAttributes(color as? [String : AnyObject], for:UIControlState())
    }
    
    class  func setTabBarTitleColorSelected(_ color:AnyObject){
        UITabBarItem.appearance().setTitleTextAttributes(color as? [String : AnyObject], for:UIControlState.selected)
    }
    
    class func setAnimation(_ tabBarController:UITabBarController ,animationtype:NSInteger){
        
        let tabBar = tabBarController.tabBar
        let tabBarItemview =  getImageViewForTabInTabBar(tabBar, index: tabBarController.selectedIndex)
        let origin:CGPoint = tabBarItemview.center
        
        
        switch animationtype {
            
        case NSAnimation_Bounce_Y:
            let target:CGPoint =  CGPoint(x: tabBarItemview.center.x, y: tabBarItemview.center.y+10);
            let bounce:CABasicAnimation = CABasicAnimation(keyPath:"position.y")
            bounce.duration = 0.4
            bounce.fromValue = origin.y
            bounce.toValue = target.y
            bounce.repeatCount = 1
            bounce.autoreverses = true
            tabBarItemview.layer .add(bounce, forKey:"position")
        case NSAnimation_Bounce_X:
            let target:CGPoint =  CGPoint(x: tabBarItemview.center.x, y: tabBarItemview.center.y);
            let bounce:CABasicAnimation = CABasicAnimation(keyPath:"position.x")
            bounce.duration = 0.4
            bounce.fromValue = origin.y
            bounce.toValue = target.y
            bounce.repeatCount = 1
            bounce.autoreverses = true
            tabBarItemview.layer .add(bounce, forKey:"position")
            
        case NSAnimation_FILP_TOP:
            UIView.transition(with: tabBarItemview, duration: 1.5, options:UIViewAnimationOptions.transitionFlipFromTop, animations: { () -> Void in
                }, completion: { (Bool) -> Void in
            })
        case NSAnimation_FILP_BOTTOM:
            UIView.transition(with: tabBarItemview, duration: 1.5, options:UIViewAnimationOptions.transitionFlipFromBottom, animations: { () -> Void in
                }, completion: { (Bool) -> Void in
            })
        case NSAnimation_FILP_LEFT:
            UIView.transition(with: tabBarItemview, duration: 1.5, options:UIViewAnimationOptions.transitionFlipFromLeft, animations: { () -> Void in
                }, completion: { (Bool) -> Void in
            })
        case NSAnimation_FILP_RIGHT:
            UIView.transition(with: tabBarItemview, duration: 1.5, options:UIViewAnimationOptions.transitionFlipFromRight, animations: { () -> Void in
                }, completion: { (Bool) -> Void in
            })
        case NSAnimation_Cross_Dissolve:
            UIView.transition(with: tabBarItemview, duration: 1.5, options:UIViewAnimationOptions.transitionCrossDissolve, animations: { () -> Void in
                }, completion: { (Bool) -> Void in
            })
        case NSAnimation_Fade:
           UIView.animate(withDuration: 0.6, animations: { () -> Void in
              tabBarItemview.alpha = 0;
            }, completion: { (Bool) -> Void in
                UIView.animate(withDuration: 0.6, animations: { () -> Void in
                    tabBarItemview.alpha = 1;
                })
           })

           
        case NSAnimation_CurlUp:
            UIView.transition(with: tabBarItemview, duration: 1.5, options:UIViewAnimationOptions.transitionCurlUp, animations: { () -> Void in
                }, completion: { (Bool) -> Void in
            })
        case NSAnimation_CurlDown:
            UIView.transition(with: tabBarItemview, duration: 1.5, options:UIViewAnimationOptions.transitionCurlDown, animations: { () -> Void in
                }, completion: { (Bool) -> Void in
            })

        default:
            print("is not a vowel or a consonant")
           
        }
    }
    
    
    class func getImageViewForTabInTabBar(_ tabBar:UITabBar ,index:NSInteger)->UIView{
        
        var currentIndex:NSInteger = 0
      
        for subView:UIView in tabBar.subviews{
            
            if(subView .isKind(of: NSClassFromString("UITabBarButton")!)){
                
                if (currentIndex == index){
                     for imgView:UIView in subView.subviews{
                        
                          if(imgView .isKind(of: NSClassFromString("UITabBarSwappableImageView")!)){
                            
                             return imgView ;
                          }
                    }
                }else{
                  currentIndex += 1;
                }
            }
        }
        return UIView () ;
    }
}
