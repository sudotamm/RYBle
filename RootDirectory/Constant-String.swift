//
//  Constant-String.swift
//  RootDirectory
//
//  Created by Ryan on 20/12/2016.
//  Copyright © 2016 Ryan. All rights reserved.
//

enum ConstantString {
    enum App: String{
        case networkError = "网络错误"
        case allDataLoaded = "已加载完所有数据"
    }
}

extension ConstantString{
    enum BleTip: String{
        case powerOn = "Bluetooth is open"
        case powerOff = "Bluetooth not open"
        case unsupported = "Bluetooth sdk not support"
        case unauthorized = "Bluetooth not authed"
        case resetting = "CBCentralManagerStateResetting"
        case unknown = "CBCentralManagerStateUnknown"
    }
    
    enum HomePage: String{
        case sample = "sample"
        case noBleFound = "No bluetooth devices found"
    }
    
    enum SettingPage: String{
        case sample = "sample"
    }
}


