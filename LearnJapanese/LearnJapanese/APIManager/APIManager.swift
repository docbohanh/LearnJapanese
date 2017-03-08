//
//  APIManager.swift
//  LearnJapanese
//
//  Created by Thuy Phan on 12/11/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

typealias ServiceResponse = (AnyObject, NSError?) -> Void
typealias AlamofireResponse = (DataResponse<Any>) -> Void

class APIManager: NSObject {
    static let sharedInstance = APIManager()
    
    func postDataToURL(url : String,parameters : [String:String],onCompletion: @escaping AlamofireResponse) {
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil)
            .responseJSON() { response in
                
                switch response.result {
                case .success(let value):
                    print("------->value: \(value)<-------")
                    DispatchQueue.global().async {
                        onCompletion(response)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
                
        }
    }
    
    func getDataToURL(url : String,parameters : [String:String],onCompletion: @escaping AlamofireResponse) {
        let parameterString = parameters.stringFromHttpParameters()
        let requestURL = url + "?" + parameterString
        
        Alamofire.request(requestURL, method: .get, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                onCompletion(response)
                print(response)
        }
    }
}
