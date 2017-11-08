//
//  AppDelegate.swift
//  Flicks
//
//  Created by Deepthy on 9/13/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        
        ThemeManager.applyTheme()
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nowPlayingNavigationController = storyboard.instantiateViewController(withIdentifier: "MovieList") as! UINavigationController
        
        let nowPlayingViewControler = nowPlayingNavigationController

        nowPlayingViewControler.tabBarItem.title = "Now Playing"
        let playingImageFromFile = UIImage(named: "NowPlaying")!
        let playingView = UIImageView(image: playingImageFromFile.withRenderingMode(UIImageRenderingMode.alwaysTemplate))

        nowPlayingViewControler.tabBarItem.image = playingView.image
        nowPlayingViewControler.tabBarItem.selectedImage = UIImage(named: "NowPlaying_filled")

        let topRatedNavigationController = storyboard.instantiateViewController(withIdentifier: "MovieList") as! UINavigationController
        let topRatedViewControler = topRatedNavigationController
        
        topRatedViewControler.tabBarItem.title = "Top Rated"
        let starImageFromFile = UIImage(named: "Star")!
        let starView = UIImageView(image: starImageFromFile.withRenderingMode(UIImageRenderingMode.alwaysTemplate))

        topRatedViewControler.tabBarItem.image = starView.image
        topRatedViewControler.tabBarItem.selectedImage = UIImage(named: "Star_filled")

        // Set up the Tab Bar Controller to have two tabs
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nowPlayingViewControler, topRatedViewControler]
        tabBarController.selectedIndex = 0
       
        // Make the Tab Bar Controller the root view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }


}

