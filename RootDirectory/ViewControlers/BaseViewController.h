//
//  BaseViewController.h
//  RootDirectory
//
//  Created by Ryan on 13-2-28.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/**
 *  左item的点击事件，默认是pop vc
 */
- (void)leftItemTapped;

/**
 *  右item的点击事件，默认空
 */
- (void)rightItemTapped;

/**
 *  中间item的点击事件，默认空
 */
- (void)extraItemTapped;

/**
 *  设置NavigationBar的title
 *
 *  @param title 需要设置的title
 */
- (void)setNaviTitle:(NSString *)title;

/**
 *  标题设置使用图片
 *  注：暂未实现
 *  @param imageName 需要用作标题的图片
 */
- (void)setNaviImageTitle:(NSString *)imageName;

/**
 *  设置基类的NavigationBar的leftItem/rightItem, item的title和image不可同时为nil。
 *  当title存在的时候用title设置，title不存在的时候用image设置
 *  注：设置image的时候如果需要用单倍图设置，直接使用图片尺寸
 *
 *  @param title     item的标题
 *  @param imageName item的图片
 */
- (void)setLeftNaviItemWithTitle:(NSString *)title imageName:(NSString *)imageName;
- (void)setRightNaviItemWithTitle:(NSString *)title imageName:(NSString *)imageName;

@end
