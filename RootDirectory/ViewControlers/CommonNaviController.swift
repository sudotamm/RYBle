//
//  CommonNaviController.swift
//  RootDirectory
//
//  Created by Ryan on 8/3/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

import UIKit

/**
 *  基于UINavigationController创建的子类，项目中得NavigationController应该都基于该类使用
 *  默认实现功能：
 *  - 基于项目MainColor处理NavigationBar
 *  - 加入自定义leftBarItem之后的pan手势不可用处理
 */
class CommonNaviController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    //MARK: UINavigationController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationBar.barTintColor = MainProjColor
        self.navigationBar.tintColor = UIColor.white
        
        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.interactivePopGestureRecognizer?.isEnabled = false
        super.pushViewController(viewController, animated: animated)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    deinit{
        self.interactivePopGestureRecognizer?.delegate = nil
        self.delegate = nil
    }
    
    //MARK: UINavigationControllerDelegate methods
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool){
        if navigationController.viewControllers.count == 1{
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }else{
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}
