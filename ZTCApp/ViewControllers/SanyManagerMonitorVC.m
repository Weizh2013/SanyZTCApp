//
//  SanyManagerMonitorVC.m
//  ZTCApp
//
//  Created by zousj on 16/6/28.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyManagerMonitorVC.h"
#import "Masonry.h"
#import "SanyPollingView.h"
#import "VehicleListViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>

@interface SanyManagerMonitorVC ()<MAMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_limitCircles;
    NSMutableArray *_forbiddenZones;
    NSMutableArray *_alarmArray;
    NSArray *_positonArray;
    NSDictionary *_resultDic;

    MAMapView *_mapView;
    MAPointAnnotation *_pointAnnotation;
    SanyPollingView *_forbiddenPollingView;
    SanyPollingView *_limitCirclePollingView;
    UIButton *_forbiddenButton;
    UIButton *_limitCircleButton;
    UIButton *_vehicleSelectButton;
    UITableView *_detailTableView;
}

- (void)didCircleButtonClicked:(UIButton *)sender;
- (void)didVehicleSelectButtonClicked:(UIButton *)sender;

@end

@implementation SanyManagerMonitorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self dataInit];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.displayVehicle != nil) {
        [SANYRequestUtils sanyVehicleDetailWithPhoneNum:self.displayVehicle[@"evPhoneNum"]
                                                 result:^(NSDictionary *_Nullable result, NSError *_Nullable error) {
                                                     if (error == nil) {
                                                         _resultDic = [result[@"devAry"] firstObject][@"dataAry"];
                                                         [self initAlarmDicWithDic:_resultDic[@"beanAlarmInfo"]];
                                                         _positonArray = [_resultDic[@"mapPosition"] componentsSeparatedByString:@";"];
                                                         [_detailTableView reloadData];
                                                         [UIView animateWithDuration:1.0
                                                                          animations:^{
                                                                              _detailTableView.frame = CGRectMake(0, self.view.bounds.size.height - 172 - 50, self.view.bounds.size.width, 172);
                                                                          }];
                                                         [self initAnnotaionWithDic:_resultDic];

                                                     } else {
                                                         [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                                                         [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                                         [SVProgressHUD showErrorWithStatus:error.domain];
                                                     }
                                                 }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.displayVehicle = nil;
    [UIView animateWithDuration:3.0
                     animations:^{
                         _detailTableView.frame = CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width, 172);
                     }];
    [_mapView removeAnnotation:_pointAnnotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark initilize
/**
 *  通过原始数据在地图上显示该点标注
 *
 *  @param dic 原始数据
 */
- (void)initAnnotaionWithDic:(NSDictionary *)dic {
    _pointAnnotation = [[MAPointAnnotation alloc] init];
    _pointAnnotation.coordinate = CLLocationCoordinate2DMake([dic[@"mapLatitude"] floatValue], [dic[@"mapLongitude"] floatValue]);
    _pointAnnotation.title = _positonArray.firstObject;
    _pointAnnotation.subtitle = _positonArray.lastObject;
    [_mapView addAnnotation:_pointAnnotation];
    [_mapView setCenterCoordinate:_pointAnnotation.coordinate animated:YES];
}

/**
 *  通过原始数据初始化报警字典
 *
 *  @param dic 原始数据
 */
- (void)initAlarmDicWithDic:(NSDictionary *)dic {
    _alarmArray = [NSMutableArray array];
    if ([dic[@"emergencyAlarm"] boolValue]) {
        [_alarmArray addObject:@"紧急报警"];
    }
    if ([dic[@"speedingAlarm"] boolValue]) {
        [_alarmArray addObject:@"超速报警"];
    }
    if ([dic[@"fatigueDriving"] boolValue]) {
        [_alarmArray addObject:@"疲劳驾驶"];
    }
    if ([dic[@"gnssFault"] boolValue]) {
        [_alarmArray addObject:@"GNSS模块发生故障"];
    }
    if ([dic[@"warning"] boolValue]) {
        [_alarmArray addObject:@"预警"];
    }
    if ([dic[@"gnssAntennaBreak"] boolValue]) {
        [_alarmArray addObject:@"GNSS天线未接或被剪断"];
    }
    if ([dic[@"gnssAntennaFault"] boolValue]) {
        [_alarmArray addObject:@"GNSS天线短路"];
    }
    if ([dic[@"terminalUndervoltage"] boolValue]) {
        [_alarmArray addObject:@"终端主电源欠压"];
    }
    if ([dic[@"terminalOutage"] boolValue]) {
        [_alarmArray addObject:@"终端主电源掉电"];
    }
    if ([dic[@"lcdFault"] boolValue]) {
        [_alarmArray addObject:@"TTS模块故障"];
    }
    if ([dic[@"cameraFault"] boolValue]) {
        [_alarmArray addObject:@"摄像头故障"];
    }
    if ([dic[@"noGpsSignal"] boolValue]) {
        [_alarmArray addObject:@"GPS无信号"];
    }
    if ([dic[@"ECUCheat"] boolValue]) {
        [_alarmArray addObject:@"ECU作弊"];
    }
    if ([dic[@"riseCheat"] boolValue]) {
        [_alarmArray addObject:@"举升作弊"];
    }
    if ([dic[@"openCloseBoxCheat"] boolValue]) {
        [_alarmArray addObject:@"开关箱作弊"];
    }
    if ([dic[@"emptyHeavyCarCheat"] boolValue]) {
        [_alarmArray addObject:@"空重车作弊"];
    }
    if ([dic[@"stealWork"] boolValue]) {
        [_alarmArray addObject:@"偷运"];
    }
    if ([dic[@"driveOverTime"] boolValue]) {
        [_alarmArray addObject:@"当天累计驾驶超时"];
    }
    if ([dic[@"packingOverTime"] boolValue]) {
        [_alarmArray addObject:@"超时停车"];
    }
    if ([dic[@"inoutArea"] boolValue]) {
        [_alarmArray addObject:@"进出区域"];
    }
    if ([dic[@"inoutPath"] boolValue]) {
        [_alarmArray addObject:@"进出路线"];
    }
    if ([dic[@"pathDeviate"] boolValue]) {
        [_alarmArray addObject:@"路线偏离"];
    }
    if ([dic[@"vssFault"] boolValue]) {
        [_alarmArray addObject:@"车辆VSS故障"];
    }
    if ([dic[@"iolMassAbr"] boolValue]) {
        [_alarmArray addObject:@"车辆油量异常"];
    }
    if ([dic[@"isStolen"] boolValue]) {
        [_alarmArray addObject:@"车辆被盗"];
    }
    if ([dic[@"illegalityFire"] boolValue]) {
        [_alarmArray addObject:@"车辆非法点火"];
    }
    if ([dic[@"illegalityMove"] boolValue]) {
        [_alarmArray addObject:@"车辆非法移位"];
    }
    if ([dic[@"turnOnOneSide"] boolValue]) {
        [_alarmArray addObject:@"碰撞侧翻报警"];
    }
    if ([dic[@"illegalRise"] boolValue]) {
        [_alarmArray addObject:@"非法举斗"];
    }
}

- (void)viewInit {
    //地图View配置
    [AMapServices sharedServices].apiKey = MAPKEY;
    _mapView = [[MAMapView alloc]
        initWithFrame:CGRectMake(0, 66, CGRectGetWidth(self.view.bounds),
                                 CGRectGetHeight(self.view.bounds) - 66 - 48)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    // 在地图上自动移动当前城市
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = [SanyStaffUtil shareUtil].coordinate;
    [_mapView setCenterCoordinate:pointAnnotation.coordinate animated:YES];
    // 车辆选择按键
    _vehicleSelectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_vehicleSelectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_vehicleSelectButton setTitle:@"车辆选择" forState:UIControlStateNormal];
    _vehicleSelectButton.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_vehicleSelectButton];
    [_vehicleSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(46);
        make.right.equalTo(self.view.mas_centerX);
    }];
    [_vehicleSelectButton addTarget:self action:@selector(didVehicleSelectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    // 禁区按键
    _forbiddenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_forbiddenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_forbiddenButton setTitle:@"禁区" forState:UIControlStateNormal];
    _forbiddenButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:_forbiddenButton];
    [_forbiddenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_vehicleSelectButton);
        make.left.equalTo(_vehicleSelectButton.mas_right);
        make.width.mas_equalTo(SCREENWIDTH / 4.0);
    }];
    [_forbiddenButton addTarget:self action:@selector(didCircleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    // 限速圈按键
    _limitCircleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_limitCircleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_limitCircleButton setTitle:@"限速圈" forState:UIControlStateNormal];
    _limitCircleButton.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_limitCircleButton];
    [_limitCircleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(_forbiddenButton);
        make.right.mas_equalTo(0);
    }];
    [_limitCircleButton addTarget:self action:@selector(didCircleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    // 车辆详情显示
    _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width, 172) style:UITableViewStylePlain];
    [_detailTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"detailCell"];
    _detailTableView.dataSource = self;
    _detailTableView.delegate = self;
    _detailTableView.separatorColor = [UIColor clearColor];
    _detailTableView.allowsSelection = NO;
    [self.view addSubview:_detailTableView];
}

- (void)dataInit {
    _forbiddenZones = [NSMutableArray array];
    _limitCircles = [NSMutableArray array];
}

#pragma mark - delegate -
- (void)mapView:(MAMapView *)mapView
    didUpdateUserLocation:(MAUserLocation *)userLocation
         updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        NSLog(@"latitude:%f,longitude:%f", userLocation.coordinate.latitude,
              userLocation.coordinate.longitude);
    }
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView
            rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolygon class]]) {
        MAPolygonRenderer *render =
            [[MAPolygonRenderer alloc] initWithOverlay:overlay];
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
    } else if ([overlay isKindOfClass:[MACircle class]]) {
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
    }
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout = YES; //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;   //设置标注动画显示，默认为NO
        annotationView.draggable = YES;      //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return _alarmArray.count;
    } else {
        return 1 + _positonArray.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"基本信息";
    } else if (section == 1) {
        return @"报警状态";
    } else {
        return @"位置信息";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    if (indexPath.section == 0) {
        cell.textLabel.textColor = [UIColor blackColor];
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"速度:%@", _resultDic[@"vehicleSpeed"]];
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"载重状态:%@", [_resultDic[@"beanStatusInfo"][@"loadState"] boolValue] ? @"有载重" : @"无载重"];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"篷布状态:%@", [_resultDic[@"beanStatusInfo"][@"tarpaulinState"] boolValue] ? @"打开" : @"关闭"];
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"举升状态:%@", [_resultDic[@"beanStatusInfo"][@"riseState"] boolValue] ? @"举升" : @"未举升"];
                break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.text = _alarmArray[indexPath.row];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"定位时间:%@", _resultDic[@"gpsTime"]];
                break;
            default:
                cell.textLabel.text = _positonArray[indexPath.row - 1];
                break;
        }
    }
    return cell;
}

#pragma mark - private -
- (void)didVehicleSelectButtonClicked:(UIButton *)sender {
    [self removeAllCircles];
    [SANYRequestUtils sanyMonitorList:^(NSDictionary *_Nullable result, NSError *_Nullable error) {
        if (error == nil) {
            VehicleListViewController *vehicleListViewController = [[VehicleListViewController alloc] init];
            vehicleListViewController.vehicleArray = result[@"rows"];
            vehicleListViewController.monitorController = self;
            [self.navigationController pushViewController:vehicleListViewController animated:YES];
        } else {
            [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

- (void)didCircleButtonClicked:(UIButton *)sender {
    if ([sender isEqual:_forbiddenButton]) {
        if (_forbiddenZones.count == 0) {
            [self forbiddenRequest];
        } else {
            [_forbiddenPollingView hidePollingViewAnimate:YES];
            [_mapView removeOverlays:_forbiddenZones];
            [_forbiddenZones removeAllObjects];
        }
    } else if ([sender isEqual:_limitCircleButton]) {
        if (_limitCircles.count == 0) {
            [self limitCircleRequest];
        } else {
            [_limitCirclePollingView hidePollingViewAnimate:YES];
            [_mapView removeOverlays:_limitCircles];
            [_limitCircles removeAllObjects];
        }
    } else {
        // 保留
    }
}

- (void)removeAllCircles {

    [_forbiddenPollingView hidePollingViewAnimate:YES];
    [_mapView removeOverlays:_forbiddenZones];
    [_forbiddenZones removeAllObjects];

    [_limitCirclePollingView hidePollingViewAnimate:YES];
    [_mapView removeOverlays:_limitCircles];
    [_limitCircles removeAllObjects];
}

- (void)forbiddenRequest {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SANYRequestUtils sanyRequestFobZoneResult:^(NSDictionary *_Nullable result,
                                                 NSError *_Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error == nil) {
            NSArray *tmpAry = result[@"rows"];
            for (NSDictionary *dic in tmpAry) {
                if ([dic[@"ef_zoneType"] integerValue] == 3) {
                    NSString *cordinates = dic[@"ef_mapCoordinates"];
                    NSArray *cordAry = [cordinates componentsSeparatedByString:@","];
                    if (cordAry.count == 3) {
                        //构造圆
                        MACircle *circle = [MACircle
                            circleWithCenterCoordinate:CLLocationCoordinate2DMake(
                                                           [cordAry[1] floatValue],
                                                           [cordAry[0] floatValue])
                                                radius:[cordAry[2] floatValue]];
                        circle.title = @"禁区";
                        //在地图上添加圆
                        [_mapView addOverlay:circle];
                        [_forbiddenZones addObject:circle];
                    }
                } else {
                    NSString *cordinates = dic[@"ef_mapCoordinates"];
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
                        MAPolygon *polygon =
                            [MAPolygon polygonWithCoordinates:coordinates
                                                        count:cordAry.count];
                        polygon.title = @"禁区";
                        // 在地图上添加多边形对象
                        [_mapView addOverlay:polygon];
                        [_forbiddenZones addObject:polygon];
                    }
                }
            }
            if (_forbiddenPollingView == nil) {
                _forbiddenPollingView = [[SanyPollingView alloc]
                    initWithTitle:@"禁区"
                            frame:CGRectMake((SCREENWIDTH - 100) / 2.0f, 70, 100, 70)
                           length:_forbiddenZones.count];
                _forbiddenPollingView.backgroundColor =
                    [UIColor colorWithValue:0xababab
                                      alpha:0.5];
                [_forbiddenPollingView addTarget:self
                                          action:@selector(showForbidden:)
                                forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:_forbiddenPollingView];
                if (_forbiddenZones.count == 1) {
                    [_forbiddenPollingView hidePollingViewAnimate:YES];
                }
            } else {
                if (_forbiddenZones.count > 1) {
                    // 至少有两个禁区才有轮询查看的必要
                    [_forbiddenPollingView showPollingViewAnimate:YES];
                }
            }
        } else {
            [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

- (void)limitCircleRequest {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SANYRequestUtils sanyRequestLimCircleResult:^(NSDictionary *_Nullable result,
                                                   NSError *_Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error == nil) {
            NSArray *tmpAry = result[@"rows"];
            for (NSDictionary *dic in tmpAry) {
                if ([dic[@"ef_zoneType"] integerValue] == 3) {
                    NSString *cordinates = dic[@"ef_mapCoordinates"];
                    NSArray *cordAry = [cordinates componentsSeparatedByString:@","];
                    if (cordAry.count == 3) {
                        //构造圆
                        MACircle *circle = [MACircle
                            circleWithCenterCoordinate:CLLocationCoordinate2DMake(
                                                           [cordAry[1] floatValue],
                                                           [cordAry[0] floatValue])
                                                radius:[cordAry[2] floatValue]];
                        circle.title = @"限速圈";
                        //在地图上添加圆
                        [_mapView addOverlay:circle];
                        [_limitCircles addObject:circle];
                    }
                } else {
                    NSString *cordinates = dic[@"ef_mapCoordinates"];
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
                        MAPolygon *polygon =
                            [MAPolygon polygonWithCoordinates:coordinates
                                                        count:cordAry.count];
                        polygon.title = @"限速圈";
                        // 在地图上添加多边形对象
                        [_mapView addOverlay:polygon];
                        [_limitCircles addObject:polygon];
                    }
                }
            }
            if (_limitCirclePollingView == nil) {
                _limitCirclePollingView = [[SanyPollingView alloc]
                    initWithTitle:@"限速圈"
                            frame:CGRectMake((SCREENWIDTH - 100) / 2.0f,
                                             SCREENHEIGHT - 120, 100, 70)
                           length:_limitCircles.count];
                _limitCirclePollingView.backgroundColor =
                    [UIColor colorWithValue:0xababab
                                      alpha:0.5];
                [_limitCirclePollingView addTarget:self
                                            action:@selector(showLimitCircle:)
                                  forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:_limitCirclePollingView];
                if (_limitCircles.count == 1) {
                    [_limitCirclePollingView hidePollingViewAnimate:YES];
                }
            } else {
                if (_limitCircles.count > 1) {
                    // 至少有两个限速圈才有轮询查看的必要
                    [_limitCirclePollingView showPollingViewAnimate:YES];
                }
            }
        } else {
            [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

- (void)showForbidden:(SanyPollingView *)pollingView {
    if (pollingView.currentPosition == 0) {
        NSLog(@"first");
        return;
    }
    id<MAOverlay> overlay = _forbiddenZones[pollingView.currentPosition - 1];
    MACoordinateRegion region = MACoordinateRegionMake(
        overlay.coordinate, MACoordinateSpanMake(0.02, 0.02));
    [_mapView setRegion:region animated:YES];
}

- (void)showLimitCircle:(SanyPollingView *)pollingView {
    if (pollingView.currentPosition == 0) {
        NSLog(@"first");
        return;
    }
    id<MAOverlay> overlay = _limitCircles[pollingView.currentPosition - 1];
    MACoordinateRegion region = MACoordinateRegionMake(
        overlay.coordinate, MACoordinateSpanMake(0.08, 0.08));
    [_mapView setRegion:region animated:YES];
}

@end
