//
//  ChaptersTableViewController.swift
//  Scripture Map
//
//  Created by Kyle on 11/26/15.
//  Copyright © 2015 Kyle Pontius. All rights reserved.
//

import UIKit
import CoreLocation

class ChaptersTableViewController: UITableViewController {
    
    // MARK: - PROPERTIES
    
    var book:Book!
    var chapters:[Chapter]!
    
    private let peekWidth = UIScreen.mainScreen().bounds.width * 0.90
    private let peekHeight = UIScreen.mainScreen().bounds.height * 0.75
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup3DTouch()
    }
    
    // MARK: - SETUP
    
    private func setup3DTouch() {
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: view)
        }
    }
    
    // MARK: - NAVIGATION
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowScripture" {
            if let destinationVC = segue.destinationViewController as? ScripturesViewController {
                destinationVC.book = book
                destinationVC.chapter = chapters[tableView.indexPathForSelectedRow!.row].chapter
            }
        }
    }
    
    // MARK: - TABLEVIEW DELEGATE
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowScripture", sender: self)
    }

    // MARK: - TABLEVIEW DATASOURCE
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = String(chapters[indexPath.row].chapter)
        
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapters.count
    }
    
    // MARK: - HELPER METHODS
    
    private func getPeekViewWithMessage(message: String, width: CGFloat, height: CGFloat) -> UIViewController {
        let messageView = storyboard?.instantiateViewControllerWithIdentifier("messageVC") as! MessageViewController
        
        messageView.message = message
        messageView.view.frame = CGRectMake(messageView.view.frame.origin.x, messageView.view.frame.origin.y, width, height)
        messageView.view.setNeedsLayout()
        messageView.view.layoutIfNeeded()
        
        return messageView
    }
}

// MARK: - 3D TOUCH DELEGATE
extension ChaptersTableViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRowAtPoint(location),
            cell = tableView.cellForRowAtIndexPath(indexPath) else { return nil }
        
        // Create a detail view controller and set its properties.
        guard let mapView = storyboard?.instantiateViewControllerWithIdentifier("mapVC") as? MapViewController else { return nil }

        // Set the source rect to the cell frame, so surrounding elements are blurred.
        previewingContext.sourceRect = cell.frame
        
        ScriptureRenderer.sharedRenderer.htmlForBookId(book.id, chapter: chapters[indexPath.row].chapter)
        let geoPlaces = ScriptureRenderer.sharedRenderer.collectedGeocodedPlaces
        
        if geoPlaces.count > 0 {
            mapView.geoLocations = geoPlaces
            mapView.navigationItem.title = "\(book.fullName) \(chapters[indexPath.row].chapter)"
            mapView.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
            mapView.navigationItem.leftItemsSupplementBackButton = true
            mapView.displayDefaultLocation = false
            mapView.view.frame = CGRectMake(mapView.view.frame.origin.x, mapView.view.frame.origin.y, peekWidth, peekHeight)
            mapView.view.layoutIfNeeded()
            
            return mapView
        } else {
            return getPeekViewWithMessage("Nothing to see here,\nmove along.", width: peekWidth, height: peekHeight / 2)
        }
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
}