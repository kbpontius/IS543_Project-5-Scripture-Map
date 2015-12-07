//
//  CustomWebView.swift
//  Scripture Map
//
//  Created by Kyle on 12/7/15.
//  Copyright © 2015 Kyle Pontius. All rights reserved.
//

import UIKit

class CustomWebView: UIWebView {
    
    var geocodingDelegate: GeocodingSuggestionDelegate?
    
    func suggestGeocode(sender: AnyObject?) {
        let highlightedText = self.stringByEvaluatingJavaScriptFromString("window.getSelection().toString()")
        
        geocodingDelegate!.didSuggestTextToGeocode(highlightedText ?? "")
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == "suggestGeocode:" {
            return true
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}

protocol GeocodingSuggestionDelegate {
    func didSuggestTextToGeocode(text: String)
    func didSuggestLocationToGeocode(latitude: Double, longitude: Double, viewLatitude: Double, viewLongitude: Double, viewTilt: Double, viewRoll: Double, viewAltitude: Double, viewHeading: Double)
}