//
//  BaseViewController.swift
//  RootDirectory
//
//  Created by Ryan on 8/3/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

import UIKit

@objc class BaseViewController: UIViewController {
    
    //MARK: Public methods
    /**
     导航栏左边按钮点击事件，默认pop到前一级页面
     */
    func leftItemTapped(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /**
     导航栏右边按钮点击事件
     */
    func rightItemTapped(){}
    
    /**
     导航栏预留点击事件
     */
    func extraItemTapped(){}
    
    /**
     设置导航栏左边按钮，文字或图标，同时设置，优先使用图标
     
     - parameter title:     按钮文字
     - parameter imageName: 按钮图标
     */
    func setLeftNaviItem(title: String, imageName: String){
        if imageName.characters.count > 0{
            let leftImage = UIImage(named: imageName)
            guard leftImage !== nil else{
                print("left image is not exist.")
                return
            }
            let leftButton = UIButton(type: UIButtonType.Custom)
            leftButton.frame = CGRectMake(0, 0, leftImage!.size.width, leftImage!.size.height)
            leftButton.addTarget(self, action: #selector(BaseViewController.leftItemTapped), forControlEvents: UIControlEvents.TouchUpInside)
            let leftItem = UIBarButtonItem(customView: leftButton)
            self.navigationItem.leftBarButtonItem = leftItem
            return
        }
        if title.characters.count > 0{
            let leftItem = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseViewController.leftItemTapped))
            self.navigationItem.leftBarButtonItem = leftItem
            return
        }
    }
    
    /**
     设置导航栏右边按钮，文字或图标，同时设置，优先使用图标
     
     - parameter title:     按钮文字
     - parameter imageName: 按钮图标
     */
    func setRightNaviItem(title: String, imageName: String){
        if imageName.characters.count > 0{
            let rightImage = UIImage(named: imageName)
            guard rightImage !== nil else{
                print("right image is not exist.")
                return
            }
            let rightButton = UIButton(type: UIButtonType.Custom)
            rightButton.frame = CGRectMake(0, 0, rightImage!.size.width, rightImage!.size.height)
            rightButton.addTarget(self, action: #selector(BaseViewController.rightItemTapped), forControlEvents: UIControlEvents.TouchUpInside)
            let rightItem = UIBarButtonItem(customView: rightButton)
            self.navigationItem.rightBarButtonItem = rightItem
            return
        }
        if title.characters.count > 0{
            let rightItem = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseViewController.rightItemTapped))
            self.navigationItem.rightBarButtonItem = rightItem
            return
        }
    }
    
    /**
     设置导航栏标题文字
     
     - parameter title: 标题文字
     */
    func setNaviTitle(title: String){
        self.navigationItem.title = title
    }
    
    /**
     设置导航栏标题图标
     
     - parameter imageName: 标题图标
     */
    func setNaviImageTitle(imageName: String){
        let imgView = UIImageView(image: UIImage(named: imageName))
        self.navigationItem.titleView = imgView
    }
}
