//
//  DetailFlashCardViewController.swift
//  LearnJapanese
//
//  Created by Nguyen Hai Dang on 12/31/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import AVFoundation

class DetailFlashCardViewController: UIViewController, UIScrollViewDelegate, RotateViewDelegate {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
     @IBOutlet weak var backgroundProgressView: UIView!

    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressWidthConstraint: NSLayoutConstraint!
   
    var listWord : [FlashCardDetail]!
    var currentIndexWord : Int!
    var audioPlayer : AVAudioPlayer?
    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupRotateView()
        self.initScrollView()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
//        wordLabel.text = word
    }
    
    func initScrollView() -> Void {
        //1
        self.scrollView.frame = CGRect(x:0, y:100, width:self.view.frame.width, height:self.view.frame.height - 110)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        self.scrollView.delegate = self
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        
        for i in 0..<listWord.count {
            let word = listWord[i]
            let customView = UINib(nibName: "RotateView", bundle: Bundle.main).instantiate(withOwner: self, options: nil)[0] as? RotateView
            customView?.frame = CGRect.init(x: 10 + CGFloat(i) * CGFloat(scrollView.frame.size.width), y: 0, width: scrollViewWidth - 20, height: scrollViewHeight)

            customView?.translateTextLabel.text = word.word
            customView?.textLabel.text = word.meaning
            customView?.clipsToBounds = true
            customView?.layer.cornerRadius = 5.0
            customView?.index = i
            customView?.delegate = self
            customView?.tag = 1000 + i
            scrollView.addSubview(customView!)
        }
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * CGFloat(listWord.count), height:self.scrollView.frame.height)
    }
    
    func setupView() -> Void {
        backgroundProgressView.clipsToBounds = true
        backgroundProgressView.layer.cornerRadius = backgroundProgressView.frame.height/2
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = progressView.frame.height/2
        
        self.scrollView.contentOffset = CGPoint.init(x: scrollView.frame.size.width*CGFloat(currentIndexWord), y: 0)
        progressWidthConstraint.constant = CGFloat((Float(currentIndexWord + 1)/Float(listWord.count)))*backgroundProgressView.frame.size.width
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
        currentIndexWord = currentPage
//        print(currentPage)
        progressWidthConstraint.constant = CGFloat((Float(currentIndexWord + 1)/Float(listWord.count)))*backgroundProgressView.frame.size.width
    }

    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* ========= ROTATE VIEW DELEGATE ======== */
    func flashCardTapped(index: Int) {
        let searchDerikuStoryboard = UIStoryboard.init(name: "SearchDekiru", bundle: Bundle.main)
        let detaiVC = searchDerikuStoryboard.instantiateViewController(withIdentifier: "WordDetailViewController") as! WordDetailViewController
        detaiVC.searchText = listWord[index].word ?? ""
        detaiVC.wordId = listWord[index].id ?? ""
        self.navigationController?.pushViewController(detaiVC, animated: true)
    }
    func favoriteTapped(index: Int) {
        let viewAnimate = view.viewWithTag(1000 + index) as! RotateView
        let option:UIViewAnimationOptions = .transitionFlipFromLeft
        UIView.transition(with: viewAnimate, duration: 0.5, options: option, animations: nil) { (isSuccess) in
            viewAnimate.isShowImage = !viewAnimate.isShowImage
            if viewAnimate.isShowImage {
                viewAnimate.textLabel.backgroundColor = UIColor.red
            }else {
                viewAnimate.textLabel.backgroundColor = UIColor.blue
            }
            
        }
        UIView.transition(with: viewAnimate, duration: 0.5, options: option, animations: nil, completion: nil)
    }
    
    func playSoundTapped(index: Int) {
        let object = listWord[index]
        if object.source_url != nil {
            let url = object.source_url
            let playerItem = AVPlayerItem( url:URL(string:url! )!)
            self.player = AVPlayer(playerItem:playerItem)
            self.player.rate = 1.0;
            self.player.play()
        }else {
            ProjectCommon.initAlertView(viewController: self, title: "", message: "Không tồn tại âm thanh này", buttonArray: ["OK"], onCompletion: { (index) in
                
            })
        }
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
//        rotateView.addGestureRecognizer(tap)
    }
}

//MARK: SELECTOR
extension DetailFlashCardViewController {
    func tapOnRotateView() {
//        rotateView.rotate()
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
