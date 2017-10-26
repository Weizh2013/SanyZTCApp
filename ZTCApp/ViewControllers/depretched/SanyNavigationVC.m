//
//  SanyNavigationVC.m
//  ZTCApp
//
//  Created by zousj on 16/7/5.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyNavigationVC.h"
#import "SanyNaviViewVC.h"
#import "MultiRoutePlanViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface SanyNavigationVC ()<MAMapViewDelegate>
{
    MAMapView               *_mapView;
    CGFloat                 _desLatitude;       // 目的地纬度
    CGFloat                 _desLongitude;      // 目的地经度
}
@end

@implementation SanyNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self dataInit];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}

#pragma mark initilize
- (void)dataInit {
    [SANYRequestUtils sanyRequestMapInfoWithMapInfo:_mapInfo type:_type result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        if (error == nil) {
            if (_type != SanyInfoTypeCar) {
                NSString *cordinates = [result[@"rows"]firstObject][@"ef_mapCoordinates"];
                NSArray *cordAry = [cordinates componentsSeparatedByString:@";"];
                if (cordAry.count >= 3) {
                    //构造多边形数据对象
                    CLLocationCoordinate2D coordinates[cordAry.count];
                    for (int i=0; i<cordAry.count; i++) {
                        NSString *cordStr           = cordAry[i];
                        NSArray *cordStrAry         = [cordStr componentsSeparatedByString:@","];
                        coordinates[i].longitude    = [cordStrAry[0]floatValue];
                        coordinates[i].latitude     = [cordStrAry[1]floatValue];
                    }
                    _desLatitude    = coordinates[0].latitude;
                    _desLongitude   = coordinates[0].longitude;
                    MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:cordAry.count];
                    // 在地图上添加多边形对象
                    [_mapView addOverlay: polygon];
                    
                    // 在地图上自动移动到多边形区域
                    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
                    pointAnnotation.coordinate = CLLocationCoordinate2DMake(coordinates[0].latitude, coordinates[0].longitude);
                    [_mapView setCenterCoordinate:pointAnnotation.coordinate animated:YES];
                }
            }else {
                /// TODO: 车辆行车情况
                _desLatitude    = [[result[@"devAry"]firstObject][@"dataAry"][@"latitude"]floatValue];
                _desLongitude   = [[result[@"devAry"]firstObject][@"dataAry"][@"longitude"]floatValue];
                
                // 在地图上自动移动到车辆位置并显示
                MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
                pointAnnotation.coordinate = CLLocationCoordinate2DMake(_desLatitude, _desLongitude);
                [_mapView addAnnotation:pointAnnotation];
                [_mapView setCenterCoordinate:pointAnnotation.coordinate animated:YES];
            }
        }else {
            /// TOOD: 网络请求错误处理
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)viewInit {
    self.navigationItem.title = _mapTitle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"导航" style:UIBarButtonItemStylePlain target:self action:@selector(navBtClicked:)];
    //地图View配置
    [AMapServices sharedServices].apiKey = MAPKEY;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
}

#pragma mark private
- (void)navBtClicked:(UIBarButtonItem *)sender {
    /*
    SanyNaviViewVC *naviViewVC = [[SanyNaviViewVC alloc]init];
    naviViewVC.desLatitude = _desLatitude;
    naviViewVC.desLongitude = _desLongitude;
    [self.navigationController pushViewController:naviViewVC animated:YES];
     */
    MultiRoutePlanViewController *routePlanVC = [[MultiRoutePlanViewController alloc]init];
    routePlanVC.desLatitude = _desLatitude;
    routePlanVC.desLongitude = _desLongitude;
    [self.navigationController pushViewController:routePlanVC animated:YES];
}

#pragma mark delegate
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

// 多边形样式
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonView *polygonView = [[MAPolygonView alloc] initWithPolygon:overlay];
        
        polygonView.lineWidth = 1.f;
        polygonView.strokeColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
        polygonView.fillColor = [UIColor colorWithValue:0xff0000 alpha:0.5];
//        polygonView.lineJoinType = kMALineJoinMiter;//连接类型
        
        return polygonView;
    }
    return nil;
}


@end
