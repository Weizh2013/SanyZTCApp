//
//  SanyDriverAboutVC.m
//  ZTCApp
//
//  Created by zousj on 16/7/1.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyDriverAboutVC.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#define CollectLength 50     // 50米以上就采集

@interface SanyDriverAboutVC ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
    MAMapPoint _oldPoint;   // 装上一次的点
    BOOL _firstLocation;    // 是否为第一次定位到
    BOOL _startGraphics;    // 开始绘制
    NSMutableArray<CLLocation *> *_locations;
}
@end

@implementation SanyDriverAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"绘制地图";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"开始" style:UIBarButtonItemStylePlain target:self action:@selector(graphicRoute:)];
    
    //地图View配置
    [AMapServices sharedServices].apiKey = MAPKEY;
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64.0-55.0)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    // 在地图上自动定位到当前位置
    _mapView.showsUserLocation = YES;       // 关闭定位
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _mapView.showsUserLocation = YES;
    _firstLocation = NO;
    _startGraphics = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.showsUserLocation = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 绘制地图开始和结束键
- (void)graphicRoute:(UIBarButtonItem *)bt {
    if (_startGraphics == NO) {
        _startGraphics = YES;
        _firstLocation = NO;
        bt.title = @"完成";
    }else {
        _startGraphics = NO;
        bt.title = @"开始";
    }
}

/* 画路线 */
- (void)drawRouteWithAry:(NSArray<CLLocation *> *)locations {
    if (locations.count >= 2) {
        //构造折线数据对象,每次画最后两个点
        CLLocationCoordinate2D coordinates[2];
        for (int i=1; i<=2; i++) {
            coordinates[i-1].longitude    = locations[locations.count-i].coordinate.longitude;
            coordinates[i-1].latitude     = locations[locations.count-i].coordinate.latitude;
        }
        MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:coordinates count:2];
        commonPolyline.title = @"路线";
        //在地图上添加折线对象
        [_mapView addOverlay: commonPolyline];
    }
}

#pragma mark - <delegate>
// 位置更新
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    
    if (_startGraphics) {
        MAMapPoint newPoint;
        if (_firstLocation == NO) {
            _firstLocation = YES;
            _oldPoint = MAMapPointForCoordinate(CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude));
            newPoint = MAMapPointForCoordinate(CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude));
            _locations = [NSMutableArray arrayWithObject:userLocation.location];
        }else {
            newPoint = MAMapPointForCoordinate(CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude));
            CLLocationDistance distance = MAMetersBetweenMapPoints(_oldPoint,newPoint);
            if (distance >= CollectLength) {
                NSLog(@"dis:%f",distance);
                [_locations addObject:userLocation.location];
                [self drawRouteWithAry:_locations];
                _oldPoint = newPoint;
            }
        }
    }

}


- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineRenderer *render = [[MAPolylineRenderer alloc]initWithOverlay:overlay];
        render.lineWidth = 5.f;
        render.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1.0];
        render.lineJoinType = kMALineJoinRound;//连接类型
        render.lineCapType = kMALineCapRound;//端点类型
        return render;
    }
    return nil;
}

// 定位失败
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"定位失败");
}

@end
