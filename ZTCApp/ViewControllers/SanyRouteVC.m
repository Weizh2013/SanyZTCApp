//
//  SanyRouteVC.m
//  ZTCApp
//
//  Created by zousj on 16/9/6.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyRouteVC.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>

@interface SanyRouteVC ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
    CLLocationCoordinate2D _worksiteCenter; // 工地中心位置
    CLLocationCoordinate2D _outletCenter;   // 消纳场中心位置
}
@end

@implementation SanyRouteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self dataInit];
}

- (void)dataInit {
    [SANYRequestUtils sanyRouteById:_routeId
                             result:^(NSDictionary *_Nullable result, NSError *_Nullable error) {
                                 if (error == nil) {
                                     [self drawWorkSiteWithDic:result];
                                     [self drawOutletWithDic:result];
                                     [self drawRouteWithDic:result];
                                 } else {
                                     [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                                     [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                     [SVProgressHUD showErrorWithStatus:error.domain];
                                 }
                             }];
}

- (void)viewInit {
    //地图View配置
    self.navigationItem.title = @"路线";
    [AMapServices sharedServices].apiKey = MAPKEY;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64.0 - 44.0)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    // 在地图上自动移动当前城市
    [_mapView setCenterCoordinate:[SanyStaffUtil shareUtil].coordinate animated:YES];
}


/* 画工地 */
- (void)drawWorkSiteWithDic:(NSDictionary *)dic {
    if ([dic[@"piWorkSiteType"] integerValue] == 3) {
        NSString *cordinates = dic[@"piWorkSiteMapCoordinates"];
        NSArray *cordAry = [cordinates componentsSeparatedByString:@","];
        if (cordAry.count == 3) {
            //构造圆
            MACircle *circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake([cordAry[1] floatValue], [cordAry[0] floatValue]) radius:[cordAry[2] floatValue]];
            circle.title = @"工地";
            //在地图上添加圆
            [_mapView addOverlay:circle];
        }
    } else {
        NSString *cordinates = dic[@"piWorkSiteMapCoordinates"];
        NSArray *cordAry = [cordinates componentsSeparatedByString:@";"];
        if (cordAry.count >= 3) {
            //构造多边形数据对象
            CLLocationCoordinate2D coordinates[10];
            for (int i = 0; i < cordAry.count; i++) {
                NSString *cordStr = cordAry[i];
                NSArray *cordStrAry = [cordStr componentsSeparatedByString:@","];
                coordinates[i].longitude = [cordStrAry[0] floatValue];
                coordinates[i].latitude = [cordStrAry[1] floatValue];
            }
            MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:cordAry.count];
            polygon.title = @"工地";
            // 在地图上添加多边形对象
            [_mapView addOverlay:polygon];
        }
    }
}

/* 画消纳场 */
- (void)drawOutletWithDic:(NSDictionary *)dic {
    if ([dic[@"cfZoneType"] integerValue] == 3) {
        NSString *cordinates = dic[@"cfMapCoordinates"];
        NSArray *cordAry = [cordinates componentsSeparatedByString:@","];
        if (cordAry.count == 3) {
            //构造圆
            MACircle *circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake([cordAry[1] floatValue], [cordAry[0] floatValue]) radius:[cordAry[2] floatValue]];
            circle.title = @"消纳场";
            //在地图上添加圆
            [_mapView addOverlay:circle];
        }
    } else {
        NSString *cordinates = dic[@"cfMapCoordinates"];
        NSArray *cordAry = [cordinates componentsSeparatedByString:@";"];
        if (cordAry.count >= 3) {
            //构造多边形数据对象
            CLLocationCoordinate2D coordinates[10];
            for (int i = 0; i < cordAry.count; i++) {
                NSString *cordStr = cordAry[i];
                NSArray *cordStrAry = [cordStr componentsSeparatedByString:@","];
                coordinates[i].longitude = [cordStrAry[0] floatValue];
                coordinates[i].latitude = [cordStrAry[1] floatValue];
            }
            MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:cordAry.count];
            polygon.title = @"消纳场";
            // 在地图上添加多边形对象
            [_mapView addOverlay:polygon];
        }
    }
}

/* 画路线 */
- (void)drawRouteWithDic:(NSDictionary *)dic {
    NSString *cordinates = dic[@"rmMapOriginLonlat"];
    NSArray *cordAry = [cordinates componentsSeparatedByString:@";"];
    if (cordAry.count >= 2) {
        //构造折线数据对象
        CLLocationCoordinate2D coordinates[1000];
        for (int i = 0; i < cordAry.count; i++) {
            NSString *cordStr = cordAry[i];
            NSArray *cordStrAry = [cordStr componentsSeparatedByString:@","];
            coordinates[i].longitude = [cordStrAry[0] floatValue];
            coordinates[i].latitude = [cordStrAry[1] floatValue];
        }
        MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:coordinates count:cordAry.count];
        commonPolyline.title = @"路线";
        //在地图上添加折线对象
        [_mapView addOverlay:commonPolyline];
    }
}

#pragma mark - <mapview delegate>
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay.title isEqualToString:@"工地"]) {
        _worksiteCenter = overlay.coordinate;
    } else if ([overlay.title isEqualToString:@"消纳场"]) {
        _outletCenter = overlay.coordinate;
    }
    // 自动校准消纳场位置和工地位置的中心位置为屏幕中央
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((_worksiteCenter.latitude + _outletCenter.latitude) / 2, (_worksiteCenter.longitude + _outletCenter.longitude) / 2);
    MACoordinateSpan span = MACoordinateSpanMake(fabs(_outletCenter.latitude - _worksiteCenter.latitude) * 2, fabs(_outletCenter.longitude - _worksiteCenter.longitude) * 2);
    [_mapView setRegion:MACoordinateRegionMake(center, span) animated:YES];

    if ([overlay isKindOfClass:[MAPolygon class]]) {
        MAPolygonRenderer *render = [[MAPolygonRenderer alloc] initWithOverlay:overlay];
        render.lineWidth = 3.f;
        if ([overlay.title isEqualToString:@"工地"]) {
            render.strokeColor = [UIColor colorWithValue:0xEE0000 alpha:0.5];
            render.fillColor = [UIColor colorWithValue:0xEE4000 alpha:0.3];
        } else if ([overlay.title isEqualToString:@"消纳场"]) {
            render.strokeColor = [UIColor colorWithValue:0xF4A460 alpha:0.5];
            render.fillColor = [UIColor colorWithValue:0xEEEE00 alpha:0.3];
        }
        render.lineJoinType = kMALineJoinMiter;
        return render;
    } else if ([overlay isKindOfClass:[MACircle class]]) {
        MACircleRenderer *render = [[MACircleRenderer alloc] initWithOverlay:overlay];
        render.lineWidth = 3.f;
        if ([overlay.title isEqualToString:@"工地"]) {
            render.strokeColor = [UIColor colorWithValue:0xEE0000 alpha:0.5];
            render.fillColor = [UIColor colorWithValue:0xEE4000 alpha:0.3];
        } else if ([overlay.title isEqualToString:@"消纳场"]) {
            render.strokeColor = [UIColor colorWithValue:0xF4A460 alpha:0.5];
            render.fillColor = [UIColor colorWithValue:0xEEEE00 alpha:0.3];
        }
        render.lineJoinType = kMALineJoinMiter;
        return render;
    } else if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineRenderer *render = [[MAPolylineRenderer alloc] initWithOverlay:overlay];
        render.lineWidth = 5.f;
        render.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1.0];
        render.lineJoinType = kMALineJoinRound; //连接类型
        render.lineCapType = kMALineCapRound;   //端点类型
        return render;
    }
    return nil;
}

@end
