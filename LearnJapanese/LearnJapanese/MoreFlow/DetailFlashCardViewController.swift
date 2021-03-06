//
//  DetailFlashCardViewController.swift
//  LearnJapanese
//
//  Created by Nguyen Hai Dang on 12/31/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import AVFoundation
import MagicalRecord

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
    var wordImageArray = [UIImage]()
    var isFlashCard:Bool = false
    var wordIdArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      // Do any additional setup after loading the view.
        setupRotateView()
        self.initScrollView()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isFlashCard {
            for object in listWord {
                if object.id != nil {
                    wordIdArray.append(object.id!)
                }
            }
        }
        self.tabBarController?.tabBar.isHidden = true
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
            if word.avatar != nil {
                customView?.wordImageView.loadImage(url: word.avatar!)
            }
            if isFlashCard {
                //show like stored flashcard
            } else {
            //don't store flash card
            }
            if isFlashCard {
                customView?.flashCardButton.setImage(UIImage.init(named: "icon_btn_flashcash_flashcard"), for: UIControlState.normal)
            } else {
                customView?.flashCardButton.setImage(UIImage.init(named: "icon_btn_flashcash"), for: UIControlState.normal)
            }
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
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* ========= ROTATE VIEW DELEGATE ======== */
    func flashCardTapped(sender: UIButton, index: Int) {
        //store flash card
        if isFlashCard {
            let flashCard = listWord[index]
            let localContext = NSManagedObjectContext.mr_default()
            flashCard.mr_deleteEntity(in: localContext)
            localContext.mr_saveToPersistentStoreAndWait()
            isFlashCard = false
            sender.setImage(UIImage.init(named: "icon_btn_flashcash"), for: UIControlState.normal)
        } else {
            if wordIdArray.count > index {
                MagicalRecord.save({context in
                    let flashCard = Translate.mr_findFirst(byAttribute: "id", withValue: self.wordIdArray[index])
                    
                    let wordData = FlashCardDetail.mr_createEntity(in:context)
                    wordData?.kana = flashCard?.kana ?? ""
                    wordData?.word = flashCard?.word ?? ""
                    wordData?.source_url = flashCard?.sound_url ?? ""
                    wordData?.meaning = flashCard?.meaning_name ?? ""
                    wordData?.romaji = flashCard?.romaji ?? ""
                    wordData?.id = flashCard?.id ?? ""
                    wordData?.flash_card_id = ".flashcard"
                    wordData?.avatar = flashCard?.avatar
                }, completion: {didContext in
                    self.isFlashCard = true
                    sender.setImage(UIImage.init(named: "icon_btn_flashcash_flashcard"), for: UIControlState.normal)
                    
                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã lưu flash card thành công", buttonArray: ["Đóng"], onCompletion: {_ in})
                })
            }
        }
    }
    
    func favoriteTapped(sender: UIButton, index: Int) {
        //store word
        ProjectCommon.initAlertView(viewController: self, title: "", message: "Tính năng này chưa được sử dụng", buttonArray: ["Đóng"], onCompletion: {_ in
        
        })
    }
    
    func rotateScreen(index: Int) {
        let viewAnimate = view.viewWithTag(1000 + index) as! RotateView
        let option:UIViewAnimationOptions = .transitionFlipFromLeft
        
        UIView.transition(
            with: viewAnimate,
            duration: 0.5,
            options: option,
            animations: nil) { (isSuccess) in
                viewAnimate.isShowImage = !viewAnimate.isShowImage
                
//                if viewAnimate.isShowImage {
//                    viewAnimate.wordImageView.isHidden = true
//                }else {
//                    viewAnimate.wordImageView.isHidden = false
//                }
                
                self.setVisibilityOf(
                    viewAnimate.wordImageView,
                    to: !viewAnimate.isShowImage,
                    duration: 0.3,
                    completion: nil)
        }
        
    }
    
    /**
     Hàm ẩn hiện view
     */
    func setVisibilityOf(_ view: UIView, to visible: Bool, duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        
        if visible && view.isHidden { view.isHidden = false }
        
        UIView.animate(
            withDuration: duration,
            animations: {
                view.alpha = visible ? 1.0 : 0.0
        },
            completion: { finished in
                if !visible { view.isHidden = true }
                if let completion = completion { completion() }
        })
        
    }
    
    func rotateDetailView(index:Int) {
        let viewAnimate = view.viewWithTag(1000 + index) as! RotateView
        let option:UIViewAnimationOptions = .transitionFlipFromLeft
        UIView.transition(with: viewAnimate, duration: 0.5, options: option, animations: nil) { (isSuccess) in
            viewAnimate.isShowImage = !viewAnimate.isShowImage
            if viewAnimate.isShowImage {
                viewAnimate.wordImageView.isHidden = true
            }else {
                viewAnimate.wordImageView.isHidden = false
            }
            
        }
        UIView.transition(with: viewAnimate, duration: 0.5, options: option, animations: nil, completion: nil)
    }
    
    func playSoundTapped(sender: UIButton, index: Int) {
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
        
        _ = UITapGestureRecognizer(target: self, action: #selector(self.tapOnRotateView))
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
