//
//  APIManager.swift
//  LearnJapanese
//
//  Created by Thuy Phan on 12/11/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import Alamofire


typealias AlamofireResponse = (DataResponse<Any>) -> Void

class APIManager: NSObject {
    static let sharedInstance = APIManager()
    
    func postDataToURL(url : String,parameters : [String:String],onCompletion: @escaping AlamofireResponse) {
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                onCompletion(response)
                print(response)
        }
    }
    
    func getDataToURL(url : String,parameters : [String:String],onCompletion: @escaping AlamofireResponse) {
        let parameterString = parameters.stringFromHttpParameters()
        let requestURL = url + "?" + parameterString
        
        Alamofire.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                onCompletion(response)
                print(response)
        }
    }
}
