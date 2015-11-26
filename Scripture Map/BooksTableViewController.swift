//
//  BooksTableViewController.swift
//  Scripture Map
//
//  Created by Kyle on 11/26/15.
//  Copyright © 2015 Kyle Pontius. All rights reserved.
//

import UIKit

class BooksTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var books:[Book]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BookCell", forIndexPath: indexPath)
        cell.textLabel?.text = books[indexPath.row].fullName
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowScripture" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let destinationVC = segue.destinationViewController as? ScripturesViewController {
                    destinationVC.book = books[indexPath.row]
                    destinationVC.chapter = 1
                    destinationVC.title = books[indexPath.row].fullName
                }
            }
        }
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowScripture", sender: self)
    }
}