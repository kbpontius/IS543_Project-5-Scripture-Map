//
//  ScripturesViewController.swift
//  Scripture Map
//
//  Created by Kyle on 11/26/15.
//  Copyright © 2015 Kyle Pontius. All rights reserved.
//

import UIKit
import MapKit

class ScripturesViewController: UIViewController, GeocodingSuggestionDelegate {
    
    // MARK: - PROPERTIES
    
    var book: Book!
    var chapter = -1
    
    weak var mapViewController: MapViewController?
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var webView: CustomWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDetailVC()
        setupWebView()
    }
    
    override func viewDidLayoutSubviews() {
        configureDetailVC()
    }
    
    // MARK: - DELEGATE CALLBACK
    
    func didSuggestTextToGeocode(text: String) {
        performSegueWithIdentifier("SegueSuggestGeocode", sender: self)
    }
    
    func didSuggestLocationToGeocode(latitude: Double, longitude: Double, viewLatitude: Double, viewLongitude: Double, viewTilt: Double, viewRoll: Double, viewAltitude: Double, viewHeading: Double) {
        print(String("\(latitude) , \(longitude)"))
    }
    
    // MARK: - HELPER METHODS
    
    private func configureDetailVC() {
        if let splitVC = splitViewController {
            mapViewController = (splitVC.viewControllers.last as! UINavigationController).topViewController as? MapViewController
        } else {
            mapViewController = nil
        }
    }
    
    private func setupWebView() {
        webView.geocodingDelegate = self
        webView.delegate = self
        
        let html = ScriptureRenderer.sharedRenderer.htmlForBookId(book.id, chapter: chapter)
        mapViewController?.updateLocations(ScriptureRenderer.sharedRenderer.collectedGeocodedPlaces)
        mapViewController?.navigationItem.title = getMapTitle()
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    private func getMapTitle() -> String {
        return "\(book.fullName) \(chapter)"
    }
    
    private func getGeoplaceId(path: String) -> String? {
        let defaultPath = "http://scriptures.byu.edu/mapscrip/"
        if path.hasPrefix(defaultPath) {
            let index = path.startIndex.advancedBy(defaultPath.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            let geoplaceId = path.substringFromIndex(index)
            
            return geoplaceId
        }
        
        return nil
    }
    
    // MARK: - NAVIGATION
    
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
        } else if segue.identifier == "SegueSuggestGeocode" {
            if let suggestionVC = segue.destinationViewController as? GeocodeSuggestionViewController {
                suggestionVC.suggestGeocodeDelegate = self
                
                if let splitVC = splitViewController {
                    mapViewController = (splitVC.viewControllers.last as! UINavigationController).topViewController as? MapViewController
                    let mapCamera = mapViewController?.mapView.camera
                    suggestionVC.mapCamera = mapCamera
                }
            }
        }
    }
}

// MARK: - WEBVIEW DELEGATE
extension ScripturesViewController: UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let path = request.URL?.absoluteString {
            if let geoplaceId = getGeoplaceId(path) {
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















