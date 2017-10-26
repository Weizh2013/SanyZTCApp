//
//  SanyDrawVC.m
//  ZTCApp
//
//  Created by zousj on 16/12/28.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyDrawVC.h"
#import "Masonry.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#define CollectLength 50     // 50米以上就采集

@interface SanyDrawVC ()<MAMapViewDelegate>

@end

@implementation SanyDrawVC
{
    MAMapView   *_mapView;
    MAMapPoint  _oldPoint;                  // 装上一次的点
    UIButton    *_submitBt;                 // 提交按钮
    BOOL        _firstLocation;             // 是否为第一次定位到
    BOOL        _startGraphics;             // 开始绘制
    UIAlertController *_submitAlert;
    
    NSMutableArray<CLLocation *> *_locations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"绘制地图";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"开始" style:UIBarButtonItemStylePlain target:self action:@selector(graphicRoute:)];
    
    //地图View配置
    [AMapServices sharedServices].apiKey = MAPKEY;
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64.0)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    // 在地图上自动定位到当前位置
    _mapView.showsUserLocation = YES;       // 关闭定位
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    
    _submitBt = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:_submitBt];
    [_submitBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(-10);
        make.height.width.mas_equalTo(60);
    }];
    _submitBt.backgroundColor = [UIColor colorWithValue:0xADD8E6 alpha:1.0];
    _submitBt.layer.cornerRadius = 30.0f;
    _submitBt.layer.masksToBounds = YES;
    [_submitBt setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_submitBt setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_submitBt addTarget:self action:@selector(submitRouteData:) forControlEvents:UIControlEventTouchUpInside];
    _submitBt.enabled = NO;
    
    _submitAlert = [UIAlertController alertControllerWithTitle:@"是否上传行走轨迹" message:@"此操作不可重复" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableString *locationStr = [NSMutableString string];
        for (int i=0; i<_locations.count; i++) {
            NSString *pointStr = [NSString stringWithFormat:@"%lf,%lf;",_locations[i].coordinate.latitude,_locations[i].coordinate.longitude];
            [locationStr appendString:pointStr];
        }
        NSString *lStr = [locationStr substringToIndex:locationStr.length-1];
        NSLog(@"lStr:%@",lStr);
        [SANYRequestUtils sanyRequestDrawData:self.efNo locations:lStr result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
            if (error == nil) {
                // 提交成功，返回到根视图控制器
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else {
                [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                [SVProgressHUD showErrorWithStatus:error.domain];
            }
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [_submitAlert addAction:sureAction];
    [_submitAlert addAction:cancelAction];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    _mapView.showsUserLocation = YES;
    _firstLocation = NO;
    _startGraphics = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
        if (_locations.count >= 3) {
            _submitBt.enabled = YES;
        }
    }
}

// 提交数据
- (void)submitRouteData:(UIButton *)sender {
    [self presentViewController:_submitAlert animated:YES completion:nil];
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
    }else {
//          测试用
//          CLLocation *l1 = [[CLLocation alloc]initWithLatitude:28.236561 longitude:113.093760];
//          NSLog(@"location:(%lf,%lf)",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
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

