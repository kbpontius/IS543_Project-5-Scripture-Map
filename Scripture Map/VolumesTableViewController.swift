//
//  VolumesTableViewController.swift
//  Scripture Map
//
//  Created by Kyle on 11/26/15.
//  Copyright © 2015 Kyle Pontius. All rights reserved.
//

import UIKit

class VolumesTableViewController: UITableViewController {

    // MARK: - PROPERTIES
    
    var volumes = GeoDatabase.sharedGeoDatabase.volumes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - TABLEVIEW DATASOURCE

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return volumes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VolumeCell", forIndexPath: indexPath)
        cell.textLabel?.text = volumes[indexPath.row]
        
        return cell
    }

    // MARK: - NAVIGATION
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowBooks" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let destinationTVC = segue.destinationViewController as? BooksTableViewController {
                    destinationTVC.books = GeoDatabase.sharedGeoDatabase.booksForParentId(indexPath.row + 1)
                    destinationTVC.title = volumes[indexPath.row]
                }
            }
        }
    }
}
