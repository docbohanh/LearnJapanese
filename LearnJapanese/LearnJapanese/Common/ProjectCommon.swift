//
//  ProjectCommon.swift
//  MoneySaver
//
//  Created by Thuy Phan on 12/3/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import SystemConfiguration

typealias AlertHandler = (Int) -> Void

class ProjectCommon: NSObject {
    
    static func boundView(button: UIView,cornerRadius: CGFloat, color: UIColor, borderWith: CGFloat) -> Void {
        button.clipsToBounds = true
        button.layer.cornerRadius = cornerRadius;
        button.layer.borderWidth = 1.0
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = borderWith
    }

    static func makeCircle(button:UIView) -> Void {
        button.clipsToBounds = true
        button.layer.cornerRadius = button.frame.size.height/2;
        button.layer.borderWidth = 1.0
        button.layer.borderColor = COMMON_COLOR.cgColor
    }
    
    static func makeCircleWithBorderColor(button:UIView, color: UIColor) {
        button.clipsToBounds = true
        button.layer.cornerRadius = button.frame.size.height/2;
        button.layer.borderWidth = 1.0
        button.layer.borderColor = color.cgColor
    }
    
    static func boundViewWithCornerRadius(button: UIView,cornerRadius: CGFloat) -> Void {
        button.clipsToBounds = true
        button.layer.cornerRadius = cornerRadius;
        button.layer.borderWidth = 1.0
        button.layer.borderColor = COMMON_COLOR.cgColor
    }
    
    static func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    static func convertTimeStampToString(timeStamp : Double) -> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm  dd-MM-yyyy" //Specify your format that you want
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    //show time for each action
    static func convertTimeStampToCustomString(timeStamp : Double) -> String {
        let currentDate = Int(NSDate().timeIntervalSince1970/86400)
        let currentHour = Int(NSDate().timeIntervalSince1970/3600)
        let currentMinute = Int(NSDate().timeIntervalSince1970/60)
        
        let date = Date(timeIntervalSince1970: timeStamp/1000)
        let displayDate = Int(timeStamp/86400000)
        let displayHour = Int(timeStamp/3600000)
        let displayMinute = Int(timeStamp/60000)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        if displayDate == (currentDate - 1) {
            dateFormatter.dateFormat = "HH:mm" //Specify your format that you want
            let time = dateFormatter.string(from: date)
            return time + " Yesterday"
        } else if displayHour > (currentHour - 1) {
            return "Ago " + String(currentMinute - displayMinute) + " Minutes"
        } else if (displayHour > (currentHour - 24)) {
            return "Ago " + String(currentHour - displayHour) + " Hours"
        }
        dateFormatter.dateFormat = "HH:mm  dd-MM-yyyy" //Specify your format that you want
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    static func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func initAlertView(viewController: UIViewController,title:String, message:String, buttonArray:[String],onCompletion : @escaping AlertHandler) {
        let alertCustomView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        for i in 0..<buttonArray.count {
            alertCustomView.addAction(UIAlertAction(title: buttonArray[i], style: UIAlertActionStyle.default, handler: {(alert:UIAlertAction) in
                onCompletion(i)
            }))
        }
        viewController.present(alertCustomView, animated: true, completion: nil)
    }
    
    static func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}
