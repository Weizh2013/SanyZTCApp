//
//  SanyWorkSiteVC.m
//  ZTCApp
//
//  Created by zousj on 16/9/6.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyWorkSiteVC.h"
#import "DriveNaviViewController.h"
#import "SpeechSynthesizer.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface SanyWorkSiteVC ()<MAMapViewDelegate, DriveNaviViewControllerDelegate, AMapNaviDriveManagerDelegate>
{
    MAMapView               *_mapView;
    CLLocationCoordinate2D  _centerCoordinate;  //工地的中心位置
    AMapNaviDriveManager    *_driveManager;
    AMapLocationManager     *_locationManager;
}
@end

@implementation SanyWorkSiteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInit];
    [self viewInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _mapView.showsUserLocation = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.showsUserLocation = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dataInit {
    [SANYRequestUtils sanyWorkSiteWithId:_efId result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        if (error == nil) {
            [self drawWorkSiteWithDic:result];
        }else {
            [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

- (void)viewInit {
    self.navigationItem.title = _worksiteName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"导航" style:UIBarButtonItemStylePlain target:self action:@selector(toNavi)];
    
    //地图View配置
    [AMapServices sharedServices].apiKey = MAPKEY;
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64.0-44.0)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    // 在地图上自动移动当前城市
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = [SanyStaffUtil shareUtil].coordinate;
    [_mapView setCenterCoordinate:pointAnnotation.coordinate animated:YES];
    
    //设置定位
    _mapView.showsUserLocation = YES;                                       //YES 为打开定位，NO为关闭定位
}

/* 画工地 */
- (void)drawWorkSiteWithDic:(NSDictionary *)dic {
    if ([dic[@"efZoneType"]integerValue]==3) {
        NSString *cordinates = dic[@"efMapCoordinates"];
        NSArray *cordAry = [cordinates componentsSeparatedByString:@","];
        if (cordAry.count == 3) {
            //构造圆
            MACircle *circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake([cordAry[1]floatValue], [cordAry[0]floatValue]) radius:[cordAry[2]floatValue]];
            circle.title = @"工地";
            //在地图上添加圆
            [_mapView addOverlay: circle];
        }
    }else {
        NSString *cordinates = dic[@"efMapCoordinates"];
        NSArray *cordAry = [cordinates componentsSeparatedByString:@";"];
        if (cordAry.count >= 3) {
            //构造多边形数据对象
            CLLocationCoordinate2D coordinates[10];
            for (int i=0; i<cordAry.count; i++) {
                NSString *cordStr           = cordAry[i];
                NSArray *cordStrAry         = [cordStr componentsSeparatedByString:@","];
                coordinates[i].longitude    = [cordStrAry[0]floatValue];
                coordinates[i].latitude     = [cordStrAry[1]floatValue];
            }
            MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:cordAry.count];
            polygon.title = @"工地";
            // 在地图上添加多边形对象
            [_mapView addOverlay: polygon];
        }
    }
}

// 进入导航界面
- (void)toNavi {
    [self initDriveManager];
    [self configLocationManager];
}

- (void)configLocationManager
{
    _locationManager = [[AMapLocationManager alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error != nil) {
            [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }else {
            //定位结果
            
            AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:_centerCoordinate.latitude longitude:_centerCoordinate.longitude];
            
            // 单路径，默认
            [_driveManager calculateDriveRouteWithEndPoints:@[endPoint] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategySingleDefault];
        }
    }];
}

- (void)initDriveManager
{
    if (_driveManager == nil)
    {
        _driveManager = [[AMapNaviDriveManager alloc] init];
        [_driveManager setDelegate:self];
    }
}

- (void)driveVCInit {
    DriveNaviViewController *driveVC = [[DriveNaviViewController alloc] init];
    [driveVC setDelegate:self];
    
    //将driveView添加到AMapNaviDriveManager中
    [_driveManager addDataRepresentative:driveVC.driveView];
    
    [self.navigationController pushViewController:driveVC animated:NO];
//    [_driveManager startEmulatorNavi];
    [_driveManager startGPSNavi];
}

#pragma mark - <mapview delegate>
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    _centerCoordinate = overlay.coordinate;
    
    if ([overlay isKindOfClass:[MAPolygon class]]) {
        MAPolygonRenderer *render = [[MAPolygonRenderer alloc]initWithOverlay:overlay];
        render.lineWidth = 3.f;
        if ([overlay.title isEqualToString:@"工地"]) {
            render.strokeColor = [UIColor colorWithValue:0xEE0000 alpha:0.5];
            render.fillColor = [UIColor colorWithValue:0xEE4000 alpha:0.3];
        }/*else if ([overlay.title isEqualToString:@"消纳厂"]) {
            render.strokeColor = [UIColor colorWithValue:0xF4A460 alpha:0.5];
            render.fillColor = [UIColor colorWithValue:0xEEEE00 alpha:0.3];
        }*/
        render.lineJoinType = kMALineJoinMiter;
        return render;
    }else if ([overlay isKindOfClass:[MACircle class]]) {
        MACircleRenderer *render = [[MACircleRenderer alloc]initWithOverlay:overlay];
        render.lineWidth = 3.f;
        if ([overlay.title isEqualToString:@"工地"]) {
            render.strokeColor = [UIColor colorWithValue:0xEE0000 alpha:0.5];
            render.fillColor = [UIColor colorWithValue:0xEE4000 alpha:0.3];
        }/*else if ([overlay.title isEqualToString:@"消纳厂"]) {
            render.strokeColor = [UIColor colorWithValue:0xF4A460 alpha:0.5];
            render.fillColor = [UIColor colorWithValue:0xEEEE00 alpha:0.3];
        }*/
        render.lineJoinType = kMALineJoinMiter;
        return render;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
//        NSLog(@"latitude:%f,longitude:%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
        // 自动校准当前位置和工地位置的中心位置为屏幕中央
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake((userLocation.coordinate.latitude+_centerCoordinate.latitude)/2, (userLocation.coordinate.longitude+_centerCoordinate.longitude)/2);
        MACoordinateSpan span = MACoordinateSpanMake(fabs(userLocation.coordinate.latitude-_centerCoordinate.latitude)*2, fabs(userLocation.coordinate.longitude-_centerCoordinate.longitude)*2);
        [_mapView setRegion:MACoordinateRegionMake(center,span) animated:YES];
    }
}

#pragma mark - AMapNaviDriveManager Delegate

- (void)driveManager:(AMapNaviDriveManager *)driveManager error:(NSError *)error
{
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showErrorWithStatus:error.domain];
}

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onCalculateRouteSuccess");
    [self driveVCInit];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error
{
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showErrorWithStatus:error.domain];
}

/*
- (void)driveManager:(AMapNaviDriveManager *)driveManager didStartNavi:(AMapNaviMode)naviMode
{
    NSLog(@"didStartNavi");
}

- (void)driveManagerNeedRecalculateRouteForYaw:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"needRecalculateRouteForYaw");
}

- (void)driveManagerNeedRecalculateRouteForTrafficJam:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"needRecalculateRouteForTrafficJam");
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onArrivedWayPoint:(int)wayPointIndex
{
    NSLog(@"onArrivedWayPoint:%d", wayPointIndex);
 }
 */

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}

/*
- (void)driveManagerDidEndEmulatorNavi:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"didEndEmulatorNavi");
}

- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onArrivedDestination");
}
 */

#pragma mark - DriveNaviView Delegate

- (void)driveNaviViewCloseButtonClicked
{
    //开始导航后不再允许选择路径，所以停止导航
    [_driveManager stopNavi];
    
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    
    [self.navigationController popViewControllerAnimated:NO];
}

@end










