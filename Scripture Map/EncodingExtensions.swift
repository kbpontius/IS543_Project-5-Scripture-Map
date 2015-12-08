//
//  DictionaryEncodingExtension.swift
//  Scripture Map
//
//  Created by Kyle on 12/7/15.
//  Copyright © 2015 Kyle Pontius. All rights reserved.
//

import Foundation

extension Dictionary {
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
            let escapedValue = (value as! String).stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(escapedValue)"
        }
        
        return parameterArray.joinWithSeparator("&")
    }
}

extension String {
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString("-._~")
        
        return self.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
    }
}