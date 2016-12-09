//
//  WordDetailViewController.swift
//  LearnJapanese
//
//  Created by Thuy Phan on 12/9/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class WordDetailViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var backgroundPopupView: UIView!
    @IBOutlet weak var searchResultScrollView: UIScrollView!
    @IBOutlet weak var searchWebView: UIWebView!
    
    @IBOutlet weak var dekiruButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var wikipediaButton: UIButton!
    @IBOutlet weak var bingButton: UIButton!
    
    var popupView : SavePopupView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViewController()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViewController() -> Void {
        Common.boundView(button: dekiruButton, cornerRadius: 2.0, color: UIColor.clear, borderWith: 0)
        Common.boundView(button: googleButton, cornerRadius: 2.0, color: UIColor.clear, borderWith: 0)
        Common.boundView(button: wikipediaButton, cornerRadius: 2.0, color: UIColor.clear, borderWith: 0)
        Common.boundView(button: bingButton, cornerRadius: 2.0, color: UIColor.clear, borderWith: 0)
        self.createPopup()
    }
    
    func createPopup() -> Void {
        popupView = UINib(nibName: "SavePopupView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as? SavePopupView
        popupView?.clipsToBounds = true
        popupView?.layer.cornerRadius = 5.0
        popupView?.translatesAutoresizingMaskIntoConstraints = false
//        popupView.delegate = self
        backgroundPopupView.addSubview(popupView!)
        
        let views = ["popupView": popupView,
                     "backgroundPopUpView": backgroundPopupView]
        let width = view.frame.size.width - 30
        
        let dictMetric = ["widthPopup" : width]
        
        // 2
        var allConstraints = [NSLayoutConstraint]()
        
        // 3
        let verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[backgroundPopUpView]-(<=1)-[popupView(260)]",
            options: [.alignAllCenterX],
            metrics: nil,
            views: views)
        allConstraints += verticalConstraints
        // 4
        let horizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[backgroundPopUpView]-(<=1)-[popupView(widthPopup)]",
            options: [.alignAllCenterY],
            metrics: dictMetric,
            views: views)
        allConstraints += horizontalConstraints
        
        backgroundPopupView.addConstraints(allConstraints)
        backgroundPopupView.isHidden = true
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func tappedDeleteButton(_ sender: Any) {
    }
    @IBAction func tappedSoundButton(_ sender: Any) {
    }
    @IBAction func tappedFavoriteButton(_ sender: Any) {
        backgroundPopupView.isHidden = false
        popupView?.myFlashCardsLabel.text = "Lưu từ"
        
    }
    @IBAction func tappedSaveFlashCashButton(_ sender: Any) {
        backgroundPopupView.isHidden = false
        popupView?.myFlashCardsLabel.text = "Flash Cards của tôi"
    }
    @IBAction func tappedClosePopupButton(_ sender: Any) {
        backgroundPopupView.isHidden = true
    }
    @IBAction func tappedDekiruDictButton(_ sender: Any) {
        searchWebView.isHidden = true
        searchResultScrollView.isHidden = false
    }
    @IBAction func tappedGoogleButton(_ sender: Any) {
        searchResultScrollView.isHidden = true
        searchWebView.isHidden = false
        let url = NSURL (string: "https://translate.google.com");
        let requestObj = NSURLRequest(url: url! as URL);
        searchWebView.loadRequest(requestObj as URLRequest);
    }
    @IBAction func tappedWikipediaButton(_ sender: Any) {
        searchResultScrollView.isHidden = true
        searchWebView.isHidden = false
        let url = NSURL (string: "https://vi.wikipedia.org/wiki/Special:Search?search=love");
        let requestObj = NSURLRequest(url: url! as URL);
        searchWebView.loadRequest(requestObj as URLRequest);
    }
    @IBAction func tappedBingButton(_ sender: Any) {
        searchResultScrollView.isHidden = true
        searchWebView.isHidden = false
        let url = NSURL (string: "http://www.bing.com/search?q=love");
        let requestObj = NSURLRequest(url: url! as URL);
        searchWebView.loadRequest(requestObj as URLRequest);
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
