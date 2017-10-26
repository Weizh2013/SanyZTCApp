//
//  CheckRouteMapViewController.m
//  ZTCApp
//
//  Created by 魏宙辉 on 17/1/17.
//  Copyright © 2017年 Sany. All rights reserved.
//

#import "CheckRouteMapViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>

@interface CheckRouteMapViewController ()<MAMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    MAMapView *_mapView;
    MAPolygon *_piPolygon;
    MAPolygon *_comsutPolygon;
    MAPolyline *_commonPolyline;
    UITableView *_routeTableView;
}

@end

@implementation CheckRouteMapViewController

#pragma mark - private
- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInit];
    // 导航栏显示
    self.navigationItem.title = @"路线查看";
    // 地图View配置
    [AMapServices sharedServices].apiKey = MAPKEY;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds),
                                                           CGRectGetHeight(self.view.bounds) - 64 - 110)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    // 默认绘制第一条线路
    [self polyLineWithArray:self.routeArray.firstObject[@"pc_mapOriginLonLat"]];
    // 路线列表tableView
    _routeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 110, CGRectGetWidth(self.view.bounds), 110) style:UITableViewStylePlain];
    [self.view addSubview:_routeTableView];
    [_routeTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"routeCell"];
    _routeTableView.dataSource = self;
    _routeTableView.delegate = self;
}

- (void)dataInit {
    // 工地电子围栏
    [SANYRequestUtils projectWorkSiteWithWorkSiteId:self.piId
                                             result:^(NSDictionary *_Nullable result, NSError *_Nullable error) {
                                                 if (error == nil) {
                                                     _piPolygon = [self drawCircleWithDic:result];
                                                     [_mapView addOverlay:_piPolygon];
                                                 } else {
                                                     [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                                                     [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                                     [SVProgressHUD showErrorWithStatus:error.domain];
                                                 }
                                             }];
    // 默认第一个消纳场电子围栏
    [SANYRequestUtils projectWorkSiteWithWorkSiteId:self.routeArray.firstObject[@"pc_eiId"]
                                             result:^(NSDictionary *_Nullable result, NSError *_Nullable error) {
                                                 if (error == nil) {
                                                     _comsutPolygon = [self drawCircleWithDic:result];
                                                     [_mapView addOverlay:_comsutPolygon];
                                                 } else {
                                                     [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                                                     [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                                     [SVProgressHUD showErrorWithStatus:error.domain];
                                                 }
                                             }];
}

- (MAPolygon *)drawCircleWithDic:(NSDictionary *)dic {
    NSArray *points = dic[@"points"];
    NSString *title = dic[@"zoneName"];
    //构造多边形数据对象
    CLLocationCoordinate2D coordinates[points.count];
    for (int i = 0; i < points.count; i++) {
        coordinates[i].longitude = [points[i][@"lng"] floatValue];
        coordinates[i].latitude = [points[i][@"lat"] floatValue];
    }
    MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates
                                count:points.count];
    polygon.title = title;
    
    return polygon;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

/**
 *  地图上绘制折线
 *
 *  @param routeArray 折线数组
 */
- (void)polyLineWithArray:(NSString *)routeStr {
    [_mapView removeOverlay:_commonPolyline];
    // 将字符串转换成数组
    NSArray *routeArray = [routeStr componentsSeparatedByString:@";"];
    // 构造折线数据对象
    CLLocationCoordinate2D commonPolylineCoords[routeArray.count];
    for (int i = 0; i < routeArray.count; i++) {
        NSString *locationStr = routeArray[i];
        NSArray *locationArray = [locationStr componentsSeparatedByString:@","];
        commonPolylineCoords[i].latitude = [locationArray.lastObject floatValue];
        commonPolylineCoords[i].longitude = [locationArray.firstObject floatValue];
    }

    //构造折线对象
    _commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:routeArray.count];

    //在地图上添加折线对象
    [_mapView addOverlay:_commonPolyline];
    [_mapView setZoomLevel:13.0f animated:YES];
    //地图中心位置设置于此线路中心位置
    [_mapView setCenterCoordinate:_commonPolyline.coordinate animated:YES];
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.routeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"routeCell" forIndexPath:indexPath];
    cell.textLabel.text = self.routeArray[indexPath.row][@"ef_name"];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"请选择消纳场以查看对应路线";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self polyLineWithArray:self.routeArray[indexPath.row][@"pc_mapOriginLonLat"]];
    [_mapView removeOverlay:_comsutPolygon];
    _comsutPolygon = nil;
    [SANYRequestUtils projectWorkSiteWithWorkSiteId:self.routeArray[indexPath.row][@"pc_eiId"]
                                             result:^(NSDictionary *_Nullable result, NSError *_Nullable error) {
                                                 if (error == nil) {
                                                     _comsutPolygon = [self drawCircleWithDic:result];
                                                     [_mapView addOverlay:_comsutPolygon];
                                                 } else {
                                                     [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                                                     [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                                     [SVProgressHUD showErrorWithStatus:error.domain];
                                                 }
                                             }];
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];

        polylineRenderer.lineWidth = 8.f;
        polylineRenderer.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType = kMALineCapRound;

        return polylineRenderer;
    }else if ([overlay isKindOfClass:[MAPolygon class]]) {
        MAPolygonRenderer *render =
        [[MAPolygonRenderer alloc] initWithOverlay:overlay];
        render.lineWidth = 3.f;
        if ([overlay isEqual:_piPolygon]) {
            render.strokeColor = [UIColor colorWithValue:0xEE0000 alpha:0.5];
            render.fillColor = [UIColor colorWithValue:0x32CD32 alpha:0.3];
        } else if ([overlay isEqual:_comsutPolygon]) {
            render.strokeColor = [UIColor colorWithValue:0xF4A460 alpha:0.5];
            render.fillColor = [UIColor colorWithValue:0xEEEE00 alpha:0.3];
        }
        render.lineJoinType = kMALineJoinMiter;
        return render;
    }else if ([overlay isKindOfClass:[MACircle class]]) {
        /* 保留
        MACircleRenderer *render =
        [[MACircleRenderer alloc] initWithOverlay:overlay];
        render.lineWidth = 3.f;
        if ([overlay.title isEqualToString:@"禁区"]) {
            render.strokeColor = [UIColor colorWithValue:0xEE0000 alpha:0.5];
            render.fillColor = [UIColor colorWithValue:0xEE4000 alpha:0.3];
        } else if ([overlay.title isEqualToString:@"限速圈"]) {
            render.strokeColor = [UIColor colorWithValue:0xF4A460 alpha:0.5];
            render.fillColor = [UIColor colorWithValue:0xEEEE00 alpha:0.3];
        }
        render.lineJoinType = kMALineJoinMiter;
        return render;
         */
    }

    return nil;
}

@end
