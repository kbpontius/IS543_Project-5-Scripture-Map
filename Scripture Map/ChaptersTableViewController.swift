//
//  ChaptersTableViewController.swift
//  Scripture Map
//
//  Created by Kyle on 11/26/15.
//  Copyright © 2015 Kyle Pontius. All rights reserved.
//

import UIKit

class ChaptersTableViewController: UITableViewController {
    
    // MARK: - PROPERTIES
    
    var book:Book!
    var chapters:[Chapter]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}
