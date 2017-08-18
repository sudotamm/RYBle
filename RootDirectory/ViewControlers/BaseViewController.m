//
//  BaseViewController.m
//  RootDirectory
//
//  Created by Ryan on 13-2-28.
//  Copyright (c) 2013年 Ryan. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)leftItemTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemTapped
{}

- (void)extraItemTapped
{}

- (void)setLeftNaviItemWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    if(imageName)
    {
        UIImage *leftImage = [UIImage imageNamed:imageName];
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setImage:leftImage forState:UIControlStateNormal];
        leftButton.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
        [leftButton addTarget:self action:@selector(leftItemTapped) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftItem;
        return;
    }
    if(title)
    {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(leftItemTapped)];
        self.navigationItem.leftBarButtonItem = leftItem;
        return;
    }
}

- (void)setRightNaviItemWithTitle:(NSString *)title imageName:(NSString *)imageName
{
    if(imageName)
    {
        UIImage *rightImage = [UIImage imageNamed:imageName];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setImage:rightImage forState:UIControlStateNormal];
        rightButton.frame = CGRectMake(0, 0, rightImage.size.width, rightImage.size.height);
        [rightButton addTarget:self action:@selector(rightItemTapped) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightItem;
        return;
    }
    if(title)
    {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightItemTapped)];
        self.navigationItem.rightBarButtonItem = rightItem;
        return;
    }
}

- (void)setNaviTitle:(NSString *)title
{
    self.navigationItem.title = title;
}

- (void)setNaviImageTitle:(NSString *)imageName
{
    //设置图片标题
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    self.navigationItem.titleView = logoImageView;
}
#pragma mark - UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
@end
