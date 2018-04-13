//
//  AppDelegate.swift
//  RyanSwift
//
//  Created by Ryan on 8/3/16.
//  Copyright © 2016 Siemens. All rights reserved.
//

import UIKit
import RYUtils
import SVProgressHUD
import RYBle

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //MARK: Instance methods
    lazy var startViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartViewController")

    lazy var pannelViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PannelViewController")

    lazy var contentNaviController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RootNaviViewController")
    
    lazy var rootTabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RootTabBarViewController")
    
    //MARK: Public methods
    @objc func showPannelView(_ notification: Notification){
        self.window!.addAnimation(withType: kCATransitionFade, subtype:nil)
        if(RootTemplateType == 0){
            self.window!.rootViewController = self.pannelViewController
        }
        else if(RootTemplateType == 1){
            self.window!.rootViewController = self.contentNaviController
        }
        else{
            self.window!.rootViewController = self.rootTabBarViewController
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: UIApplicationDelegate methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        SVProgressHUD.setDefaultStyle(.dark)
        RYBleManager.sharedManager.bleInit(completion: nil) { state in
            SVProgressHUD.showError(withStatus: state.description)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.showPannelView(_:)), name: NSNotification.Name(rawValue: ShowPannelViewNotification), object: nil)
        self.window!.tintColor = MainProjColor;
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    RYAppBackgroundConfiger.clearAllCaches(whenBiggerThanSize: Double(MaxCacheSize))
    RYAppBackgroundConfiger.preventFilesFromBeingBackedupToiCloud(withSystemVersion: UIDevice.current.systemVersion)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

