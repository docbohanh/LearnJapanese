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
        Alamofire.request(Router.CreateUser(parameters as [String : AnyObject]))
            .responseJSON { response in
                onCompletion(response)
                print(response)
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
    
    func postDataToURLAsStringResponse(url : String,parameters : [String:String]) {
        Alamofire.request(Router.CreateUser(parameters as [String : AnyObject]))
            .responseString{ response in
                print(response)
        }
    }
    
    enum Router: URLRequestConvertible {
        static let baseURLString = "http://app-api.dekiru.vn/DekiruApi.ashx"
        static var OAuthToken: String?
        
        case CreateUser([String: AnyObject])
        case ReadUser(String)
        case UpdateUser(String, [String: AnyObject])
        case DestroyUser(String)
        
        var method: Alamofire.HTTPMethod {
            switch self {
            case .CreateUser:
                return .post
            case .ReadUser:
                return .get
            case .UpdateUser:
                return .put
            case .DestroyUser:
                return .delete
            }
        }
        
        var path: String {
            switch self {
            case .CreateUser:
                return "/users"
            case .ReadUser(let username):
                return "/users/\(username)"
            case .UpdateUser(let username, _):
                return "/users/\(username)"
            case .DestroyUser(let username):
                return "/users/\(username)"
            }
        }
        
        func asURLRequest() throws -> URLRequest {
            let url = URL(string: Router.baseURLString)!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            
            if let token = Router.OAuthToken {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            switch self {
            case .CreateUser(let parameters):
                return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
            case .UpdateUser(_, let parameters):
                return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
            default:
                return urlRequest
            }
        }
    }
}
