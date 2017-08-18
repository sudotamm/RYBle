//
//  RootTabBarViewController.swift
//  RootDirectory
//
//  Created by Ryan on 8/3/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

import UIKit

/**
 *  基于UITabBarController创建的子类
 *  默认实现功能：
 *  - UITabBar样式相关处理
 */
class RootTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    //MARK: UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.tintColor = MainProjColor
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: UITabBarControllerDelegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool{
        return true
    }
}
