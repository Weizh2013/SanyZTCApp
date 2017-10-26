//
//  SanyBossMonitorVC.m
//  ZTCApp
//
//  Created by zousj on 16/6/30.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyBossMonitorVC.h"
#import "Masonry.h"
#import "SanyAnnotationView.h"
#import "SanyCarCollectionCell.h"
#import "SanyCarInfoVC.h"
#import "SanyMonitorView.h"
#import "SanySearchBar.h"
#import "Tracking.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <MAMapKit/MAPolylineRenderer.h>

@interface SanyBossMonitorVC ()<MAMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TrackingDelegate>
{
    SanyMonitorView *_sanyMonitorView;
    MAMapView *_mapView;
    MAPointAnnotation *_pointAnnotation;
    UIButton *_carListBt;
    Tracking *_tracking;

    NSDictionary *_truckInfo;
    NSString *_truckNo;
    NSMutableArray *_points;

    UICollectionView *_carListCV;
    UIView *_carListBkView;

    NSArray *_carListAry;

    BOOL _carListHide;
}
@end

@implementation SanyBossMonitorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [_mapView removeAnnotation:_pointAnnotation];
    [self dataInit];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.startTime = nil;
    self.endTime = nil;
    self.speed = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark initilize
- (void)viewInit {
    //地图View配置
    [AMapServices sharedServices].apiKey = MAPKEY;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 20.0)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    // 在地图上自动移动当前城市
    [_mapView setCenterCoordinate:[SanyStaffUtil shareUtil].coordinate animated:YES];

    _sanyMonitorView = [[SanyMonitorView alloc] initWithData:nil];
    _sanyMonitorView.frame = CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width, 172);
    [self.view addSubview:_sanyMonitorView];
    [_sanyMonitorView closeView];

    _carListBkView = [[UIView alloc] initWithFrame:self.view.bounds];
    _carListBkView.backgroundColor = [UIColor colorWithValue:0x000000 alpha:0.5];
    [self.view addSubview:_carListBkView];
    _carListBkView.hidden = YES;

    _carListBt = [UIButton buttonWithType:UIButtonTypeSystem];
    [_carListBt setImage:[[UIImage imageNamed:@"icon_car_list.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    _carListBt.frame = CGRectMake(SCREENWIDTH - 54.0, 100.0, 44.0, 44.0);
    [_carListBt addTarget:self action:@selector(carListBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_carListBt];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5.0f;
    layout.minimumInteritemSpacing = 5.0f;
    layout.itemSize = CGSizeMake(70.0f, 100.0f);
    _carListHide = YES;
    _carListCV = [[UICollectionView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 10.0, 144.0f, 0, 0) collectionViewLayout:layout];
    [_carListCV registerNib:[UINib nibWithNibName:@"SanyCarCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"carCollectionCell"];
    _carListCV.dataSource = self;
    _carListCV.delegate = self;
    _carListCV.backgroundColor = [UIColor colorWithValue:0xffffff alpha:0.8];
    _carListCV.layer.cornerRadius = 5.0f;
    _carListCV.layer.masksToBounds = YES;
    _carListCV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_carListCV];
}

- (void)dataInit {

    if (self.startTime != nil && self.endTime != nil && self.speed != nil) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [SANYRequestUtils sanyOrbitWith:_truckNo
                              startTime:self.startTime
                                endTime:self.endTime
                                   page:@"1"
                                 result:^(NSDictionary *_Nullable result, NSError *_Nullable error) {
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     if (error == nil) {
                                         _points = [NSMutableArray array];
                                         [_points addObjectsFromArray:result[@"rows"]];
                                         [self trackingOrbit];
                                     } else {
                                         [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                                         [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                         [SVProgressHUD showErrorWithStatus:error.domain];
                                     }
                                 }];
    }
}

- (void)trackingOrbit {
    CLLocationCoordinate2D coordinates[_points.count];
    for (int i = 0; i < _points.count; i++) {
        NSDictionary *tmpDic = _points[i];
        coordinates[i] = CLLocationCoordinate2DMake([tmpDic[@"lat"] doubleValue], [tmpDic[@"lng"] doubleValue]);
    }
    if (_tracking == nil) {
        _tracking = [[Tracking alloc] initWithCoordinates:coordinates count:_points.count];
        NSLog(@"%ld", _points.count);
    }
    _tracking.delegate = self;
    _tracking.mapView = _mapView;
    _tracking.duration = _points.count * self.speed.doubleValue / 10000;
    _tracking.edgeInsets = UIEdgeInsetsMake(50, 50, 50, 50);
    [_tracking execute];
}

- (void)trackingClear {
    [_tracking clear];
    _tracking = nil;
}

- (void)hideCarList {
    _carListHide = YES;
    _carListBkView.hidden = _carListHide;
    [UIView animateWithDuration:0.3
                     animations:^{
                         _carListCV.frame = CGRectMake(SCREENWIDTH - 10.0, 144.0f, 0, 0);
                     }];
    [_mapView removeAnnotation:_pointAnnotation];
    _pointAnnotation = nil;
}

- (void)showCarList {
    _carListHide = NO;
    _carListBkView.hidden = _carListHide;
    [UIView animateWithDuration:0.3
                     animations:^{
                         _carListCV.frame = CGRectMake(10.0f, 144.0f, SCREENWIDTH - 20.0f, 200);
                     }];
    [_carListCV reloadData];
    [_sanyMonitorView closeView]; // 收起监控视图
}

- (void)carListBtClicked:(UIButton *)sender {
    [self trackingClear];
    if (_carListHide) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [SANYRequestUtils sanyRequestCarListStartTime:[SanyStaffUtil shareUtil].startTime
                                              endTime:[SanyStaffUtil shareUtil].endTime
                                               result:^(NSDictionary *_Nullable result, NSError *_Nullable error) {
                                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                   if (error == nil) {
                                                       _carListAry = result[@"rows"];
                                                       [self showCarList];
                                                   } else {
                                                       [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                                                       [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                                       [SVProgressHUD showErrorWithStatus:error.domain];
                                                   }
                                               }];
    } else {
        [self hideCarList];
    }
}

#pragma mark delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _carListAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SanyCarCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"carCollectionCell" forIndexPath:indexPath];
    NSDictionary *carInfo = _carListAry[indexPath.row];
    cell.sanyImgView.image = [[UIImage imageNamed:@"icon_car_list.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    cell.sanyPlateLb.text = carInfo[@"evVehiNo"];       //evEquiNo
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self hideCarList];
    /// TODO: 查询车辆位置
    NSDictionary *carInfo = _carListAry[indexPath.row];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SANYRequestUtils sanyRequestMapInfoWithMapInfo:carInfo
                                               type:SanyInfoTypeCar
                                             result:^(NSDictionary *_Nullable result, NSError *_Nullable error) {
                                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                 if (error == nil) {
                                                     _truckNo = carInfo[@"evEquiNo"];
                                                     _truckInfo = [result[@"devAry"] firstObject][@"dataAry"];
                                                     if (_pointAnnotation == nil) {
                                                         _pointAnnotation = [[MAPointAnnotation alloc] init];
                                                     } else {
                                                         [_mapView removeAnnotation:_pointAnnotation];
                                                     }
                                                     _pointAnnotation.coordinate = CLLocationCoordinate2DMake([_truckInfo[@"mapLatitude"] floatValue], [_truckInfo[@"mapLongitude"] floatValue]);
                                                     [_mapView addAnnotation:_pointAnnotation];
                                                     [_mapView setCenterCoordinate:_pointAnnotation.coordinate animated:YES];

                                                     NSDate *currentDate = [NSDate date];
                                                     NSDate *beforeDate = [NSDate dateWithTimeInterval:-24 * 60 * 60 sinceDate:currentDate]; //半小时前,测试在一天前
                                                     NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                                                     dateFormat.dateFormat = @"HH:mm:ss";
                                                     NSString *startTime = [dateFormat stringFromDate:beforeDate];
                                                     NSString *endTime = [dateFormat stringFromDate:currentDate];
                                                     [SANYRequestUtils sanyRequestMonitorWithStartTime:startTime
                                                                                               endTime:endTime
                                                                                                 carNo:carInfo[@"evVehiNo"]
                                                                                                result:^(NSDictionary *_Nullable result, NSError *_Nullable error) {
                                                                                                    if (error == nil) {
                                                                                                        _sanyMonitorView.disAry = result[@"rows"];
                                                                                                        if (_sanyMonitorView.disAry.count > 0) {
                                                                                                            [_sanyMonitorView showView];
                                                                                                            [_sanyMonitorView reloadData];
                                                                                                        } else {
                                                                                                            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                                                                                            [SVProgressHUD showInfoWithStatus:@"无报警信息"];
                                                                                                        }
                                                                                                    } else {
                                                                                                        [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                                                                                                        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                                                                                        [SVProgressHUD showErrorWithStatus:error.domain];
                                                                                                    }
                                                                                                }];
                                                 } else {
                                                     [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                                                     [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                                     [SVProgressHUD showErrorWithStatus:error.domain];
                                                 }
                                             }];
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        NSLog(@"latitude:%f,longitude:%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    }
}

/* 自定义定位图标 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    /*
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        SanyAnnotationView *annotationView = (SanyAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[SanyAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        if ([_truckInfo[@"angle"]integerValue]<180) {
            annotationView.image = [UIImage imageNamed:@"che1"];
        }else {
            annotationView.image = [UIImage imageNamed:@"che2"];
        }
        annotationView.canShowCallout= NO;       //设置气泡可以弹出，默认为NO
        annotationView.truckInfo = _truckInfo;
        return annotationView;
        
        
    }
    return nil;
    */

    /*
    static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
    SanyAnnotationView *annotationView = (SanyAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
    if (annotationView == nil)
    {
        annotationView = [[SanyAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
    }
    annotationView.truckInfo = _truckInfo;
    annotationView.canShowCallout= NO;     //设置气泡可以弹出，默认为NO
    annotationView.animatesDrop = YES;      //设置标注动画显示，默认为NO
    annotationView.draggable = YES;         //设置标注可以拖动，默认为NO
    annotationView.pinColor = MAPinAnnotationColorPurple;
    return annotationView;
     */

    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout = NO; //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;  //设置标注动画显示，默认为NO
        annotationView.draggable = YES;     //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {

    self.speed = nil;
    self.startTime = nil;
    self.endTime = nil;

    SanyCarInfoVC *carInfoVC = [SanyCarInfoVC new];
    carInfoVC.carNo = _truckNo;
    carInfoVC.carInfo = _truckInfo;
    carInfoVC.bossMonitorVC = self;
    [self.navigationController pushViewController:carInfoVC animated:YES];
}

- (void)didEndTracking:(Tracking *)tracking {
    [_mapView removeAnnotation:_pointAnnotation];
}

@end
