//
//  SanyMapVC.m
//  ZTCApp
//
//  Created by zousj on 16/7/22.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyMapVC.h"
#import "DriveNaviViewController.h"
#import "SpeechSynthesizer.h"
//#import "MultiRoutePlanViewController.h"

@interface SanyMapVC () <MAMapViewDelegate, DriveNaviViewControllerDelegate, AMapNaviDriveManagerDelegate>
{
    MAMapView               *_mapView;
    CGFloat                 _desLatitude;       // 目的地纬度
    CGFloat                 _desLongitude;      // 目的地经度
    CLLocationCoordinate2D  _coordinates[20];
    NSInteger               _coordinateCount;
}
@end

@implementation SanyMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
    [self dataInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}

#pragma mark initilize
- (void)dataInit {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SANYRequestUtils sanyRequestMapInfoWithMapInfo:_mapInfo type:_type result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error == nil) {
            if (_type != SanyInfoTypeCar) {
                NSString *cordinates = [result[@"rows"]firstObject][@"ef_mapCoordinates"];
                NSArray *cordAry = [cordinates componentsSeparatedByString:@";"];
                if (cordAry.count >= 3) {
                    //构造多边形数据对象
                    _coordinateCount = cordAry.count;
                    for (int i=0; i<cordAry.count; i++) {
                        NSString *cordStr           = cordAry[i];
                        NSArray *cordStrAry         = [cordStr componentsSeparatedByString:@","];
                        _coordinates[i].longitude    = [cordStrAry[0]floatValue];
                        _coordinates[i].latitude     = [cordStrAry[1]floatValue];
                    }
                    _desLatitude    = _coordinates[0].latitude;
                    _desLongitude   = _coordinates[0].longitude;
                    MAPolygon *polygon = [MAPolygon polygonWithCoordinates:_coordinates count:_coordinateCount];
                    
                    // 在地图上添加多边形对象
                    [_mapView addOverlay: polygon];
                    // 在地图上自动移动到多边形区域
                    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
                    pointAnnotation.coordinate = CLLocationCoordinate2DMake(_desLatitude, _desLongitude);
                    [_mapView setCenterCoordinate:pointAnnotation.coordinate animated:YES];
                    MACoordinateRegion region = MACoordinateRegionMake(_coordinates[0],MACoordinateSpanMake(0.02,0.02));
                    [_mapView setRegion:region animated:YES];
                }
            }else {
                /// TODO: 车辆行车情况
//                _desLatitude    = [[result[@"devAry"]firstObject][@"dataAry"][@"latitude"]floatValue];
//                _desLongitude   = [[result[@"devAry"]firstObject][@"dataAry"][@"longitude"]floatValue];
                _desLatitude = 28.23;
                _desLongitude = 112.93;
                
                // 在地图上自动移动到车辆位置并显示
                MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
                pointAnnotation.coordinate = CLLocationCoordinate2DMake(_desLatitude, _desLongitude);
                [_mapView addAnnotation:pointAnnotation];
                [_mapView setCenterCoordinate:pointAnnotation.coordinate animated:YES];
            }
        }else {
            [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

- (void)viewInit {
    self.navigationItem.title = _mapTitle;
    if (_type != SanyInfoTypeCar) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"导航" style:UIBarButtonItemStylePlain target:self action:@selector(navBtClicked:)];
    }
    //地图View配置
    [AMapServices sharedServices].apiKey = MAPKEY;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64)];
    _mapView.mapType = MAMapTypeStandard;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
}

#pragma mark private
- (void)navBtClicked:(UIBarButtonItem *)sender {
/*
    MultiRoutePlanViewController *routePlanVC = [[MultiRoutePlanViewController alloc]init];
    routePlanVC.desLatitude = _desLatitude;
    routePlanVC.desLongitude = _desLongitude;
    [self.navigationController pushViewController:routePlanVC animated:YES];
 */
    // 一步进入导航界面
    [self initDriveManager];
    [self configLocationManager];
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error != nil) {
            [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }else {
            //定位结果
            self.startPoint = [AMapNaviPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
            
            self.endPoint = [AMapNaviPoint locationWithLatitude:_desLatitude longitude:_desLongitude];
            
            // 单路径，默认
            [self.driveManager calculateDriveRouteWithEndPoints:@[self.endPoint] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategySingleDefault];
        }
    }];
}

- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
    }
}

- (void)driveVCInit {
    DriveNaviViewController *driveVC = [[DriveNaviViewController alloc] init];
    [driveVC setDelegate:self];
    
    //将driveView添加到AMapNaviDriveManager中
    [self.driveManager addDataRepresentative:driveVC.driveView];
    
    [self.navigationController pushViewController:driveVC animated:NO];
    [self.driveManager startEmulatorNavi];
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
//    [self showNaviRoutes];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error
{
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showErrorWithStatus:error.domain];
}

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

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}

- (void)driveManagerDidEndEmulatorNavi:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"didEndEmulatorNavi");
}

- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onArrivedDestination");
}

#pragma mark - DriveNaviView Delegate

- (void)driveNaviViewCloseButtonClicked
{
    //开始导航后不再允许选择路径，所以停止导航
    [self.driveManager stopNavi];
    
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark map view delegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        NSLog(@"latitude:%f,longitude:%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

// 标注样式
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"logo.jpg"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolygon class]]) {
        MAPolygonRenderer *render = [[MAPolygonRenderer alloc]initWithOverlay:overlay];
        render.lineWidth = 5.f;
        render.strokeColor = kMAOverlayRendererDefaultStrokeColor;
        render.fillColor = kMAOverlayRendererDefaultFillColor;
        render.lineJoinType = kMALineJoinMiter;
        return render;
    }
    return nil;
}

@end
