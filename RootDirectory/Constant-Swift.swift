//
//  Constant-Swift.swift
//  RootDirectory
//
//  Created by Ryan on 8/3/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

import UIKit

/*
 0 - 标识使用root vc = PannelViewController
 1 - 标识使用root vc = RootNaviViewController - HomeViewController as root
 2 - 标识使用root vc = RootTabBarViewController - CommonNaviController - HomeViewController as root
 */
let RootTemplateType = 1

//MARK: RYProject External Values
//Apple Api
let AppAppleId = "563444753"
let AppRateUrl = "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@"
let AppDownloadUrl = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8"

//External Values
let MaxCacheSize = 500*1024*1024
let MainProjColor = UIColor(red: 0.10, green: 0.66, blue: 0.69, alpha: 1.0)

//External Methods
func DocumentFolder() -> String{
    return NSHomeDirectory() + "/Documents/"
}

func IsIPad() -> Bool{
    return UI_USER_INTERFACE_IDIOM() == .pad
}

func IsIos7Later() -> Bool{
    return Float(UIDevice.current.systemVersion) ?? 0.0 > 7.0
}

func IsIos8Later() -> Bool{
    return Float(UIDevice.current.systemVersion) ?? 0.0 > 8.0
}

func IsIos9Later() -> Bool{
    return Float(UIDevice.current.systemVersion) ?? 0.0 > 9.0
}

func Is3_5Inch() -> Bool{
    return UIScreen.main.bounds.size.height == 480.0
}

func Is4Inch() -> Bool{
    return UIScreen.main.bounds.size.height == 568.0
}

func Is4_7Inch() -> Bool{
    return UIScreen.main.bounds.size.height == 667.0
}

func Is5_5Inch() -> Bool{
    return UIScreen.main.bounds.size.height == 736.0
}

//MARK: App Constant Values
//Notification Values
let ShowPannelViewNotification = "ShowPannelViewNotification"

//Url Values
#if RYAN_DEBUG
let IPAddress = "http://www.debug.com"
#else
let IPAddress = "http://www.release.com"
#endif
let ServerAddress = IPAddress + ""
