//
//  SanyNaviViewVC.m
//  ZTCApp
//
//  Created by zousj on 16/7/21.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyNaviViewVC.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

@interface SanyNaviViewVC ()<AMapNaviDriveManagerDelegate,AMapNaviDriveViewDelegate>
{
    AMapNaviDriveManager    *_driveManager;
    AMapNaviDriveView       *_naviDriveView;
}
@end

@implementation SanyNaviViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"导航";
    if (_driveManager == nil) {
        _driveManager = [[AMapNaviDriveManager alloc] init];
        [_driveManager setDelegate:self];
        [_driveManager setAllowsBackgroundLocationUpdates:YES];
    }
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:_desLatitude longitude:_desLongitude];
    NSArray *endPoints = @[endPoint];
    [_driveManager calculateDriveRouteWithEndPoints:endPoints wayPoints:nil drivingStrategy:AMapNaviDrivingStrategyDefault];
    if (_naviDriveView == nil) {
        
        _naviDriveView = [[AMapNaviDriveView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64.0f)];
        _naviDriveView.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    //停止导航
    [_driveManager stopNavi];
    //将naviDriveView从AMapNaviDriveManager中移除
    [_driveManager removeDataRepresentative:_naviDriveView];
    //将导航视图从视图层级中移除
    [_naviDriveView removeFromSuperview];
}

#pragma mark <rout delegate>
/**
 *  发生错误时,会调用代理的此方法
 *
 *  @param error 错误信息
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager error:(NSError *)error {
    NSLog(@"err:%@",error);
}

/**
 *  驾车路径规划成功后的回调函数
 */
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager {
    NSLog(@"驾车路径规划成功");
    
}

/**
 *  驾车路径规划失败后的回调函数
 *
 *  @param error 错误信息,error.code参照AMapNaviCalcRouteState
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error {
    NSLog(@"驾车路径规划失败");
    //将naviDriveView添加到AMapNaviDriveManager中
    [_driveManager addDataRepresentative:_naviDriveView];
    
    //将导航视图添加到视图层级中
    [self.view addSubview:_naviDriveView];
    
    //开始实时导航
    [_driveManager startGPSNavi];
}

/**
 *  启动导航后回调函数
 *
 *  @param naviMode 导航类型，参考AMapNaviMode
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager didStartNavi:(AMapNaviMode)naviMode {
    NSLog(@"启动导航");
}

/**
 *  出现偏航需要重新计算路径时的回调函数
 */
- (void)driveManagerNeedRecalculateRouteForYaw:(AMapNaviDriveManager *)driveManager {
    NSLog(@"出现偏航需要重新计算路径时的回调函数");
}

/**
 *  前方遇到拥堵需要重新计算路径时的回调函数
 */
- (void)driveManagerNeedRecalculateRouteForTrafficJam:(AMapNaviDriveManager *)driveManager {
    NSLog(@"前方遇到拥堵需要重新计算路径时的回调函数");
}

/**
 *  导航到达某个途经点的回调函数
 *
 *  @param wayPointIndex 到达途径点的编号，标号从1开始
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager onArrivedWayPoint:(int)wayPointIndex {
    NSLog(@"导航到达某个途经点的回调函数");
}

/**
 *  导航播报信息回调函数
 *
 *  @param soundString 播报文字
 *  @param soundStringType 播报类型,参考AMapNaviSoundType
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType {
    NSLog(@"导航播报信息回调函数");
}

/**
 *  模拟导航到达目的地停止导航后的回调函数
 */
- (void)driveManagerDidEndEmulatorNavi:(AMapNaviDriveManager *)driveManager {
    NSLog(@"模拟导航到达目的地停止导航后的回调函数");
}

/**
 *  导航到达目的地后的回调函数
 */
- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager {
    NSLog(@"导航到达目的地后的回调函数");
}

#pragma mark <naviView delegate>
/**
 *  导航界面关闭按钮点击时的回调函数
 */
- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView {
    
}

/**
 *  导航界面更多按钮点击时的回调函数
 */
- (void)driveViewMoreButtonClicked:(AMapNaviDriveView *)driveView {
    
}

/**
 *  导航界面转向指示View点击时的回调函数
 */
- (void)driveViewTrunIndicatorViewTapped:(AMapNaviDriveView *)driveView {
    
}

/**
 *  导航界面显示模式改变后的回调函数
 *
 *  @param showMode 显示模式
 */
- (void)driveView:(AMapNaviDriveView *)driveView didChangeShowMode:(AMapNaviDriveViewShowMode)showMode {
    
}

@end
