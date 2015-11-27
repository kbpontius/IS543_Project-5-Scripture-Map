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
    
    var chapters:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - TABLEVIEW DATASOURCE
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = chapters[indexPath.row]
        
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapters.count
    }
}
