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
    var highlightedText = ""
    var highlightedTextOffset = ""
    
    weak var mapViewController: MapViewController?
    lazy var backgroundQueue = dispatch_queue_create("background thread", nil)
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var webView: CustomWebView!
    
    // MARK: - VIEW METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDetailVC()
        setupWebView()
    }
    
    override func viewDidLayoutSubviews() {
        configureDetailVC()
    }
    
    // MARK: - DELEGATE CALLBACK
    
    func didSuggestTextToGeocode(highlightedText: String, offset: String) {
        self.highlightedText = highlightedText
        self.highlightedTextOffset = offset
        
        performSegueWithIdentifier("SegueSuggestGeocode", sender: self)
    }
    
    func didSuggestLocationToGeocode(latitude: String, longitude: String, viewLatitude: String, viewLongitude: String, viewTilt: String, viewRoll: String, viewAltitude: String, viewHeading: String) {
        hideContextMenu()
        
        dispatch_async(backgroundQueue) {
            let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
            
            config.allowsCellularAccess = true
            config.timeoutIntervalForRequest = 15.0
            config.timeoutIntervalForResource = 15.0
            config.HTTPMaximumConnectionsPerHost = 2
            
            let parametersDictionary = ["placename" : self.highlightedText, "offset" : self.highlightedTextOffset, "latitude" : latitude, "longitude" : longitude, "viewLatitude" : viewLatitude, "viewLongitude" : viewLongitude, "viewTilt" : viewTilt, "viewRoll" : viewRoll, "viewAltitude" : viewAltitude, "viewHeading" : viewHeading, "bookId" : String(self.book.id), "chapter" : String(self.book.numChapters > 1 ? self.chapter : 0)]
            let session = NSURLSession(configuration: config)
            let requestURL = "http://scriptures.byu.edu/mapscrip/suggestpm.php?\(parametersDictionary.stringFromHttpParameters())"
            let request = NSURLRequest(URL: NSURL(string: requestURL)!)
            
            var succeeded = false
            
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if error != nil {
                    print("ERROR: \(error)")
                } else {
                    if let resultData = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) {
                        if let resultDictionary = resultData as? NSDictionary {
                            if let code = resultDictionary["result"] as? Int {
                                if code == 0 {
                                    succeeded = true
                                }
                            }
                        }
                    }
                }
                
                if !succeeded {
                    dispatch_async(dispatch_get_main_queue()) {
                        let alertController = UIAlertController(title: "ERROR", message: "Failed to connect.\nPlease check your network connection.", preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    // MARK: - ACTION METHODS
    
    @IBAction func cancelSuggestionUnwind(segue: UIStoryboardSegue) {
        hideContextMenu()
    }
    
    // MARK: - HELPER METHODS
    
    private func hideContextMenu() {
        webView.userInteractionEnabled = false
        webView.userInteractionEnabled = true
    }
    
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















