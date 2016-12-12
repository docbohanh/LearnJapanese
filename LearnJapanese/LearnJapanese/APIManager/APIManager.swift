//
//  APIManager.swift
//  LearnJapanese
//
//  Created by Thuy Phan on 12/11/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
typealias ServiceResponse = (AnyObject, NSError?) -> Void

class APIManager: NSObject {
    static let sharedInstance = APIManager()
    
    let baseURL = "http://api.randomuser.me/"
    
    func makeHTTPGetRequest(path: String, onCompletion: @escaping ServiceResponse) {
        var request = URLRequest(url: NSURL(string: path) as! URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
//            let json:JSON = JSON(data: data)
            guard let json = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: AnyObject] else { return }
            print("json:", json)
            onCompletion(json as AnyObject, error as NSError?)
        })
        task.resume()
    }
    func makeHTTPPostRequest(path: String, body: [String: AnyObject], onCompletion: @escaping ServiceResponse) {
        var request = URLRequest(url: NSURL(string: path) as! URL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Set the method to POST
        request.httpMethod = "POST"
        
        // Set the POST body for the request
        request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
//            let json:JSON = JSON(data: data)
            guard let json = try! JSONSerialization.jsonObject(with: data!, options:[]) as? [String: AnyObject] else { return }
            print("json:", json)
            onCompletion(json as AnyObject, error as NSError?)
        })
        task.resume()
    }
}
