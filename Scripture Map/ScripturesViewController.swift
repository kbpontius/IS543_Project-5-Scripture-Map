//
//  ScripturesViewController.swift
//  Scripture Map
//
//  Created by Kyle on 11/26/15.
//  Copyright © 2015 Kyle Pontius. All rights reserved.
//

import UIKit
import MapKit

class ScripturesViewController: UIViewController {
    
    // MARK: - Properties
    
    var book: Book!
    var chapter = -1
    
    weak var mapViewController: MapViewController?
    
    // MARK: - Outlets
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDetailVC()
        setupWebView()
    }
    
    override func viewDidLayoutSubviews() {
        configureDetailVC()
    }
    
    // MARK: - Helper Methods
    
    private func configureDetailVC() {
        if let splitVC = splitViewController {
            mapViewController = (splitVC.viewControllers.last as! UINavigationController).topViewController as? MapViewController
        } else {
            mapViewController = nil
        }
    }
    
    private func setupWebView() {
        webView.delegate = self
        
        let html = ScriptureRenderer.sharedRenderer.htmlForBookId(book.id, chapter: chapter)
        webView.loadHTMLString(html, baseURL: nil)
        mapViewController?.updateLocations(ScriptureRenderer.sharedRenderer.collectedGeocodedPlaces)
        mapViewController?.navigationItem.title = getMapTitle()
    }
    
    private func getMapTitle() -> String {
        return "\(book.fullName) \(chapter)"
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMap" {
            if let navigationVC = segue.destinationViewController as? UINavigationController {
                if let mapVC = navigationVC.topViewController as? MapViewController {
                    let geoPlace = sender as? GeoPlace
                    let locations = geoPlace != nil ? [geoPlace!] : ScriptureRenderer.sharedRenderer.collectedGeocodedPlaces
                    mapVC.geoLocations = locations
                    mapVC.navigationItem.title = getMapTitle()
                    mapVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
                    mapVC.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }
    }
}

// MARK: - WebView Delegate
extension ScripturesViewController: UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let path = request.URL?.absoluteString {
            let defaultPath = "http://scriptures.byu.edu/mapscrip/"
            if path.hasPrefix(defaultPath) {
                let index = path.startIndex.advancedBy(defaultPath.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
                let geoplaceId = path.substringFromIndex(index)
                
                if mapViewController == nil {
                    performSegueWithIdentifier("ShowMap", sender: GeoDatabase.sharedGeoDatabase.geoPlaceForId(Int(geoplaceId)!)!)
                } else {
                    mapViewController!.updateLocations([GeoDatabase.sharedGeoDatabase.geoPlaceForId(Int(geoplaceId)!)!], animate: false)
                }
                
                return false
            }
        }
        
        return true
    }
}
