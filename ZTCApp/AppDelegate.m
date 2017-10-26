//
//  AppDelegate.m
//  ZTCApp
//
//  Created by zousj on 16/6/28.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "AppDelegate.h"
#import "SanyBossMainVC.h"
#import "SanyBossMonitorVC.h"
#import "SanyBossRegisterVC.h"
#import "SanyBossStatisticVC.h"
#import "SanyCheckViewController.h"
#import "SanyDriverAboutVC.h"
#import "SanyDriverMainVC.h"
#import "SanyDriverMonitorVC.h"
#import "SanyDriverStaVC.h"
#import "SanyLoginVC.h"
#import "SanyManagerAboutVC.h"
#import "SanyManagerMainVC.h"
#import "SanyManagerMonitorVC.h"
#import "SanyManagerStatisticVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma application process
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self loginCtrlInit];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma controllers init
// 登陆界面视图
- (void)loginCtrlInit {
    SanyLoginVC *loginVC = [[SanyLoginVC alloc] initWithNibName:@"SanyLoginVC" bundle:[NSBundle mainBundle]];
    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];
}

// 管理者登陆后的视图
- (void)managerCtrlsInit {
    SanyManagerMainVC *mainVC = [[SanyManagerMainVC alloc] init];
    SanyManagerMonitorVC *monitorVC = [[SanyManagerMonitorVC alloc] init];
    SanyManagerStatisticVC *statisticVC = [[SanyManagerStatisticVC alloc] init];
    SanyManagerAboutVC *aboutVC = [[SanyManagerAboutVC alloc] init];
    SanyCheckViewController *checkVC = [[SanyCheckViewController alloc] init];

    UINavigationController *mainNavVC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    UINavigationController *monitorNavVC = [[UINavigationController alloc] initWithRootViewController:monitorVC];
    UINavigationController *statisticNavVC = [[UINavigationController alloc] initWithRootViewController:statisticVC];
    UINavigationController *aboutNavVC = [[UINavigationController alloc] initWithRootViewController:aboutVC];
    UINavigationController *checkNavVC = [[UINavigationController alloc] initWithRootViewController:checkVC];

    UITabBarController *tabBarCtrl = [[UITabBarController alloc] init];
    tabBarCtrl.viewControllers = @[ mainNavVC, monitorNavVC, checkNavVC, statisticNavVC, aboutNavVC ];
    tabBarCtrl.tabBar.tintColor = [UIColor redColor];
    tabBarCtrl.delegate = monitorVC;
    mainNavVC.tabBarItem.title = @"首页";
    mainNavVC.tabBarItem.image = [[UIImage imageNamed:@"a-icon-home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mainNavVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"a-icon-home-active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    monitorNavVC.tabBarItem.title = @"监控";
    monitorNavVC.tabBarItem.image = [[UIImage imageNamed:@"a-icon-realmonitor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    monitorNavVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"a-icon-realmonitor-active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    checkNavVC.tabBarItem.title = @"审核";
    checkNavVC.tabBarItem.image = [[UIImage imageNamed:@"a-icon-realmonitor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    checkNavVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"a-icon-realmonitor-active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    statisticNavVC.tabBarItem.title = @"统计";
    statisticNavVC.tabBarItem.image = [[UIImage imageNamed:@"a-icon-statisanalys"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    statisticNavVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"a-icon-statisanalys-active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    aboutNavVC.tabBarItem.title = @"工具";
    aboutNavVC.tabBarItem.image = [[UIImage imageNamed:@"a-icon-about"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    aboutNavVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"a-icon-about-active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.window.rootViewController = tabBarCtrl;
    [self.window makeKeyAndVisible];
}

// 老板登陆后的视图
- (void)bossCtrlsInit {
    SanyBossMainVC *mainVC = [[SanyBossMainVC alloc] init];
    SanyBossMonitorVC *monitorVC = [[SanyBossMonitorVC alloc] init];
    SanyBossStatisticVC *statisticVC = [[SanyBossStatisticVC alloc] init];
    SanyBossRegisterVC *registerVC = [[SanyBossRegisterVC alloc] init];

    UINavigationController *mainNavVC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    UINavigationController *monitorNavVC = [[UINavigationController alloc] initWithRootViewController:monitorVC];
    UINavigationController *statisticNavVC = [[UINavigationController alloc] initWithRootViewController:statisticVC];
    UINavigationController *aboutNavVC = [[UINavigationController alloc] initWithRootViewController:registerVC];

    UITabBarController *tabBarCtrl = [[UITabBarController alloc] init];
    tabBarCtrl.viewControllers = @[ mainNavVC, monitorNavVC, statisticNavVC, aboutNavVC ];
    tabBarCtrl.delegate = monitorVC;
    tabBarCtrl.tabBar.tintColor = [UIColor redColor];
    mainNavVC.tabBarItem.title = @"首页";
    mainNavVC.tabBarItem.image = [[UIImage imageNamed:@"a-icon-home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mainNavVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"a-icon-home-active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    monitorNavVC.tabBarItem.title = @"监控";
    monitorNavVC.tabBarItem.image = [[UIImage imageNamed:@"a-icon-realmonitor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    monitorNavVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"a-icon-realmonitor-active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    statisticNavVC.tabBarItem.title = @"统计";
    statisticNavVC.tabBarItem.image = [[UIImage imageNamed:@"a-icon-statisanalys"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    statisticNavVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"a-icon-statisanalys-active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    aboutNavVC.tabBarItem.title = @"办证";
    aboutNavVC.tabBarItem.image = [[UIImage imageNamed:@"a-icon-about"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    aboutNavVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"a-icon-about-active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.window.rootViewController = tabBarCtrl;
    [self.window makeKeyAndVisible];
}
// 司机登陆后的视图
- (void)driverCtrlsInit {
    SanyDriverMainVC *mainVC = [[SanyDriverMainVC alloc] init];
    SanyDriverMonitorVC *monitorVC = [[SanyDriverMonitorVC alloc] init];
    SanyDriverStaVC *statisticVC = [[SanyDriverStaVC alloc] init];
    SanyDriverAboutVC *aboutVC = [[SanyDriverAboutVC alloc] init];

    UINavigationController *mainNavVC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    UINavigationController *monitorNavVC = [[UINavigationController alloc] initWithRootViewController:monitorVC];
    UINavigationController *statisticNavVC = [[UINavigationController alloc] initWithRootViewController:statisticVC];
    UINavigationController *aboutNavVC = [[UINavigationController alloc] initWithRootViewController:aboutVC];

    UITabBarController *tabBarCtrl = [[UITabBarController alloc] init];
    tabBarCtrl.viewControllers = @[ mainNavVC, monitorNavVC, statisticNavVC, aboutNavVC ];
    tabBarCtrl.tabBar.tintColor = [UIColor redColor];
    tabBarCtrl.delegate = monitorVC;
    mainNavVC.tabBarItem.title = @"首页";
    mainNavVC.tabBarItem.image = [[UIImage imageNamed:@"a-icon-home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mainNavVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"a-icon-home-active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    monitorNavVC.tabBarItem.title = @"监控";
    monitorNavVC.tabBarItem.image = [[UIImage imageNamed:@"a-icon-realmonitor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    monitorNavVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"a-icon-realmonitor-active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    statisticNavVC.tabBarItem.title = @"统计";
    statisticNavVC.tabBarItem.image = [[UIImage imageNamed:@"a-icon-statisanalys"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    statisticNavVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"a-icon-statisanalys-active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    aboutNavVC.tabBarItem.title = @"关于";
    aboutNavVC.tabBarItem.image = [[UIImage imageNamed:@"a-icon-about"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    aboutNavVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"a-icon-about-active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.window.rootViewController = tabBarCtrl;
    [self.window makeKeyAndVisible];
}

@end
