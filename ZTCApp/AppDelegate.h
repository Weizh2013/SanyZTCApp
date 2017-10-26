//
//  AppDelegate.h
//  ZTCApp
//
//  Created by zousj on 16/6/28.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 * 登录页面初始化
 */
- (void)loginCtrlInit;
/**
 * 管理者登陆页面初始化
 */
- (void)managerCtrlsInit;
/**
 * 老板登陆页面初始化
 */
- (void)bossCtrlsInit;
/**
 * 司机登陆页面初始化
 */
- (void)driverCtrlsInit;

@end

