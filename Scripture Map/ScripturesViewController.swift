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
    
    // MARK: - Outlets
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let html = ScriptureRenderer.sharedRenderer.htmlForBookId(book.id, chapter: chapter)
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
