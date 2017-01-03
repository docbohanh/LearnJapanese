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
        DispatchQueue.main.async {
            if self.sound_url == nil {
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Không tồn tại âm thanh này", buttonArray: ["Đóng"], onCompletion: {_ in
                })
            } else {
                let playerItem = AVPlayerItem( url:URL(string:self.sound_url )! )
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
