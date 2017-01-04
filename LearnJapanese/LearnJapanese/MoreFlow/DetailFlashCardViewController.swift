//
//  DetailFlashCardViewController.swift
//  LearnJapanese
//
//  Created by Nguyen Hai Dang on 12/31/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import AVFoundation

class DetailFlashCardViewController: UIViewController {
    
    @IBOutlet weak var rotateView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var helloLabel: UILabel!
    var word:String = ""
    var sound_url:String = ""
    var player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupRotateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wordLabel.text = word
    }
    @IBAction func tappedStoreWord(_ sender: UIButton) {
    }
    
    @IBAction func tappedBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tappedSound(_ sender: Any) {
        //        DispatchQueue.main.async {
        //            if self.sound_url == nil {
        //                ProjectCommon.initAlertView(viewController: self, title: "", message: "Không tồn tại âm thanh này", buttonArray: ["Đóng"], onCompletion: {_ in
        //                })
        //            } else {
        //                let playerItem = AVPlayerItem( url:URL(string:self.sound_url )! )
        //                self.player = AVPlayer(playerItem:playerItem)
        //                self.player.rate = 1.0;
        //                self.player.play()
        //            }
        //        }
        
        ///Thành Lã: 2016/01/05
        DispatchQueue.main.async {
            if self.sound_url.characters.count == 0 {
                ProjectCommon.initAlertView(
                    viewController: self,
                    title: "",
                    message: "Không tìm thấy âm thanh",
                    buttonArray: ["Đóng"],
                    onCompletion: {_ in
                })
            } else {
                
                guard let url = URL(string:self.sound_url) else { return }
                
                let playerItem = AVPlayerItem(url: url)
                self.player = AVPlayer(playerItem:playerItem)
                self.player.rate = 1.0;
                self.player.play()
            }
        }
    }
    
    @IBAction func tappedFavorite(_ sender: UIButton) {
    }
    @IBOutlet weak var tappedBack: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

//Thành Lã: 2016/01/05---------------
//MARK: PRIVATE METHOD
//-----------------------------------
extension DetailFlashCardViewController {
    fileprivate func setupRotateView() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOnRotateView))
        rotateView.addGestureRecognizer(tap)
    }
}

//MARK: SELECTOR
extension DetailFlashCardViewController {
    func tapOnRotateView() {
        rotateView.rotate()
    }
}


extension UIView {
    
    func rotate() {
        if self.layer.animation(forKey: "cdImage") == nil {
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotateAnimation.toValue = M_PI * 2
            rotateAnimation.duration = 1 // 1 seconds
            rotateAnimation.repeatCount = 0
            rotateAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            self.layer.speed = 1
            self.layer.add(rotateAnimation, forKey: "cdImage")
        }
    }
}
