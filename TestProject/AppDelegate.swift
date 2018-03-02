//
//  AppDelegate.swift
//  TestProject
//
//  Created by Patel, Sanjay on 3/31/17.
//  Copyright © 2017 Patel, Sanjay. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.black
        
        return true
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

