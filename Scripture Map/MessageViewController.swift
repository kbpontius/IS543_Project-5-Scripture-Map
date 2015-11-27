//
//  MessageViewController.swift
//  Scripture Map
//
//  Created by Kyle on 11/27/15.
//  Copyright © 2015 Kyle Pontius. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    @IBOutlet weak var lblMessage: UILabel!
    
    var message:String!
    
    override func viewDidLoad() {
        lblMessage.text = message
    }
}
