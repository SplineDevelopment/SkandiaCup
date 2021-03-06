//
//  AppDelegate.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import UIKit
    
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let defaults = NSUserDefaults.standardUserDefaults()
    var window: UIWindow?
    var lastDate: NSDate?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let configFromDisk = defaults.objectForKey("config") as? NSData
        if(configFromDisk == nil){
            getFromFtp()
        } else{
            if let config = NSKeyedUnarchiver.unarchiveObjectWithData(configFromDisk!){
                SharingManager.config = config as! Config
            }
        }
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.darkGrayColor()
        
        
        //navigationBarAppearace.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        // navigationBarAppearace.shadowImage = UIImage()
        navigationBarAppearace.translucent = true
        
        // UITabBar.appearance().barTintColor = UIColor(red: 41.0/255.0, green: 40.0/255.0, blue: 39.0/255.0, alpha: 1.0)
        UITabBar.appearance().barTintColor = UIColor.whiteColor()
        UITabBar.appearance().tintColor = UIColor(red:0.02, green:0.54, blue:0.02, alpha:1.0)
        //UITabBar.appearance().backgroundImage = UIImage()
        
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
        if let last = SharingManager.config.lastdate{
            let today = NSDate()
            let timeSinceLast = today.timeIntervalSinceDate(last)
            if timeSinceLast > 30 {
                getFromFtp();
            }
        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func getFromFtp(){
        GetFromFTP.openAndGetConfigJSON({ () -> Void in
            SharingManager.config.lastdate = NSDate();
            let data = NSKeyedArchiver.archivedDataWithRootObject(SharingManager.config)
            self.defaults.setObject(data, forKey: "config")
        })
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

