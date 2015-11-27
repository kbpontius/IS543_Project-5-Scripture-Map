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

    // MARK: - Properties
    var window: UIWindow?

    // MARK: - Lifecycle
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers.last as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController,
        collapseSecondaryViewController secondaryViewController:UIViewController,
        ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let _ = secondaryAsNavController.topViewController as? MapViewController else { return false }
        
        return false
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

