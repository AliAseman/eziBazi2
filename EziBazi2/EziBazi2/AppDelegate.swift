//
//  AppDelegate.swift
//  EziBazi2
//
//  Created by AliArabgary on 9/13/18.
//  Copyright © 2018 AliArabgary. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    internal func makeCircular(_ view:UIView){
        // imageFram.layer.borderWidth = 1
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.height/5
        view.clipsToBounds = true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("application")
        UINavigationBar.appearance().tintColor = UIColor.ezibaziThem
        UITabBar.appearance().tintColor = UIColor.ezibaziThem
        UITabBar.appearance().barTintColor = UIColor.black
        UISegmentedControl.appearance().tintColor = UIColor.ezibaziThem
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.white], for: .normal)
        UISearchBar.appearance().tintColor = UIColor.ezibaziThem
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.white], for: .selected)
        UISearchBar.appearance().semanticContentAttribute = .forceRightToLeft
       
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
         print("applicationDidEnterBackground")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("applicationDidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

