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
        
        var length: Int {
            return self.characters.count
        }
        
        subscript (i: Int) -> String {
            return self[Range(i ..< i + 1)]
        }
        
        func substring(from: Int) -> String {
            return self[Range(min(from, length) ..< length)]
        }
        
        func substring(to: Int) -> String {
            return self[Range(0 ..< max(0, to))]
        }
        
        subscript (r: Range<Int>) -> String {
            let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                                upper: min(length, max(0, r.upperBound))))
            let start = index(startIndex, offsetBy: range.lowerBound)
            let end = index(start, offsetBy: range.upperBound - range.lowerBound)
            return self[Range(start ..< end)]
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
