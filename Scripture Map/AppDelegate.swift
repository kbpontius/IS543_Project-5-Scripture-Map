//
//  AppDelegate.swift
//  Scripture Map
//
//  Created by Kyle on 11/26/15.
//  Copyright © 2015 Kyle Pontius. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    // MARK: - PROPERTIES
    var window: UIWindow?

    // MARK: - LIFECYCLE
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers.last as! UINavigationController
        
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self
        
        return true
    }

    // MARK: - SPLITVIEW

    func splitViewController(splitViewController: UISplitViewController,
        collapseSecondaryViewController secondaryViewController:UIViewController,
        ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let _ = secondaryAsNavController.topViewController as? MapViewController else { return false }
        
        return true
    }
    
    func splitViewController(splitViewController: UISplitViewController,
        separateSecondaryViewControllerFromPrimaryViewController primaryViewController: UIViewController) -> UIViewController? {
        
            if let navigationVC = primaryViewController as? UINavigationController {
                for controller in navigationVC.viewControllers {
                    if let controllerVC = controller as? UINavigationController {
                        // This is the default detail view controller.
                        return controllerVC
                    }
                }
            }
    
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailView = storyboard.instantiateViewControllerWithIdentifier("detailVC") as! UINavigationController
            
            // Enable back button.
            if let controller = detailView.visibleViewController {
                controller.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
            
            return detailView
    }
}

