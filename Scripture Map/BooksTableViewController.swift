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
    
    // MARK: - NAVIGATION
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            if segue.identifier == "ShowScripture" {
                
            } else if segue.identifier == "ShowChapters" {
                if let destinationVC = segue.destinationViewController as? ChaptersTableViewController {
                    destinationVC.chapters = getChapters(books[indexPath.row])
                }
            }
        }
    }
    
    // MARK: - HELPER
    
    private func hasOnlyOneChapter(book: Book) -> Bool {
        return book.numChapters < 2
    }
    
    private func getChapters(book: Book) -> [String] {
        let result = GeoDatabase.sharedGeoDatabase.chaptersForBook(book)
        return result.map { String($0.chapter) }
    }
    
    // MARK: - TABLEVIEW DELEGATE
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if hasOnlyOneChapter(books[indexPath.row]) {
            performSegueWithIdentifier("ShowScripture", sender: self)
        } else {
            performSegueWithIdentifier("ShowChapters", sender: self)
        }
    }
}