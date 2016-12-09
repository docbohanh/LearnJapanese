//
//  StringExtension.swift
//  MoneySaver
//
//  Created by Hai Dang Nguyen on 12/9/16.
//  Copyright © 2016 McLab. All rights reserved.
//

import Foundation

    extension String {
        func stringByAddingPercentEncodingForURLQueryValue() -> String? {
            let allowedCharacters = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
            
            return self.self.addingPercentEncoding(withAllowedCharacters: allowedCharacters as CharacterSet)
        }
    }
    
    extension Dictionary {
        func stringFromHttpParameters() -> String {
            let parameterArray = self.map { (key, value) -> String in
                let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
                let percentEscapedValue = (value as! String).stringByAddingPercentEncodingForURLQueryValue()!
                return "\(percentEscapedKey)=\(percentEscapedValue)"
            }
            
            return parameterArray.joined(separator: "&")
        }
}
