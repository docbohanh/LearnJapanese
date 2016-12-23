//
//  LoadingOverlay.swift
//  MoneySaver
//
//  Created by Thuy Phan on 12/17/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import Foundation
import UIKit


public class LoadingOverlay{
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView!) {
        overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        let loadingView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 130, height: 70))
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
        loadingView.center = overlayView.center
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 5.0
        overlayView.addSubview(loadingView)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.center = overlayView.center
        overlayView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(overlayView)
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
