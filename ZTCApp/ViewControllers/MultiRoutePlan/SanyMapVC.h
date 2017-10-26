//
//  SanyMapVC.h
//  ZTCApp
//
//  Created by zousj on 16/7/22.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyBaseVC.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface SanyMapVC : SanyBaseVC

@property (nonatomic,copy)      NSString        *mapTitle;
@property (nonatomic,strong)    NSDictionary    *mapInfo;
@property (nonatomic,assign)    SanyInfoType    type;

@property (nonatomic,strong)    AMapLocationManager     *locationManager;
@property (nonatomic,strong)    AMapNaviPoint           *startPoint;
@property (nonatomic,strong)    AMapNaviPoint           *endPoint;
@property (nonatomic,strong)    AMapNaviDriveManager    *driveManager;

@end
