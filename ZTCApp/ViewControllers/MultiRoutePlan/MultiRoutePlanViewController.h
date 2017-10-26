//
//  MultiRoutePlanViewController.h
//  AMapNaviKit
//
//  Created by 刘博 on 16/3/7.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface MultiRoutePlanViewController : UIViewController

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapNaviDriveManager *driveManager;

@property (nonatomic, strong) AMapLocationManager  *locationManager;

@property (nonatomic,assign) CGFloat desLatitude;

@property (nonatomic,assign) CGFloat desLongitude;

@end
