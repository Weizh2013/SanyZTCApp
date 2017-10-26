//
//  SanyBossStatisticVC.m
//  ZTCApp
//
//  Created by zousj on 16/6/30.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyBossStatisticVC.h"
#import "SanyMainTableViewCell.h"
#import "SanyChartTableViewCell.h"
#import "SanyStaListVC.h"
#import "Masonry.h"

typedef NS_ENUM(NSInteger, SanyStaType) {
    SanyStaTypeNone     =  0,    // 不显示柱状图
    SanyStaTypeMonth    =  1,    // 显示月趟次柱状图
    SanyStaTypeYear     =  2,    // 显示年趟次柱状图
};

@interface SanyBossStatisticVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView         *_statisticTV;
    UISegmentedControl  *_segCtrl;
    NSArray             *_timeTitleAry;
    NSArray             *_timesAry;
    NSArray             *_categoryTitleAry;
    NSArray             *_categorysAry;
    NSMutableArray      *_xLbs;
    NSMutableArray      *_yLbs;
    
    SanyStaType         _sanyStaType;
}
@end

@implementation SanyBossStatisticVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
    [self dataInit];
    [self staDataWithRefresh:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark initilize
- (void)dataInit {
    _sanyStaType = SanyStaTypeNone;         // 默认不显示
    _timeTitleAry       = @[@"当日趟次",@"当月趟次",@"当年趟次"];
    _timesAry           = @[@0,@0,@0];
    _categoryTitleAry   = @[@"按类型",@"按车辆"];
    _categorysAry       = @[@0,@0];
}

- (void)staDataWithRefresh:(BOOL)isRefresh {
    if (!isRefresh) {
        [_statisticTV.mj_header endRefreshing];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [SANYRequestUtils sanyRequestBossStaticWithStartTime:[SanyStaffUtil shareUtil].startTime endTime:[SanyStaffUtil shareUtil].endTime result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        if (isRefresh) {
            [_statisticTV.mj_header endRefreshing];
        }else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        if (error == nil) {
            NSArray *resultAry = result[@"rows"];
            NSNumber *n0,*n1,*n2;
            for (int i=0; i<resultAry.count; i++) {
                NSDictionary *dic = resultAry[i];
                if ([[dic[@"label"]description]isEqualToString:@"当日趟次"]) {
                    n0 = @([dic[@"value"]integerValue]);
                }else if ([[dic[@"label"]description]isEqualToString:@"当月趟次"]) {
                    n1 = @([dic[@"value"]integerValue]);
                }else {
                    n2 = @([dic[@"value"]integerValue]);
                }
            }
            _timesAry = @[n0,n1,n2];
            [_statisticTV reloadData];
        }else {
            [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

- (void)alarmDataWithRefresh:(BOOL)isRefresh {
    if (!isRefresh) {
        [_statisticTV.mj_header endRefreshing];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [SANYRequestUtils sanyRequestBossAlarmWithStartTime:[SanyStaffUtil shareUtil].startTime endTime:[SanyStaffUtil shareUtil].endTime result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        if (isRefresh) {
            [_statisticTV.mj_header endRefreshing];
        }else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        if (error == nil) {
            NSArray *resultAry = result[@"rows"];
            NSNumber *n0,*n1;
            for (int i=0; i<resultAry.count; i++) {
                NSDictionary *dic = resultAry[i];
                if ([[dic[@"label"]description]isEqualToString:@"按报警类型统计"]) {
                    n0 = @([dic[@"value"]integerValue]);
                }else if ([[dic[@"label"]description]isEqualToString:@"按报警车辆统计"]) {
                    n1 = @([dic[@"value"]integerValue]);
                }
            }
            _categorysAry = @[n0,n1];
            [_statisticTV reloadData];
        }else {
            [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

- (void)viewInit {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"统计分析";
    
    _segCtrl = [[UISegmentedControl alloc]initWithItems:@[@"运输趟次统计",@"报警信息统计"]];
    _segCtrl.backgroundColor = [UIColor colorWithValue:0xe0e0e0 alpha:1.0];
    _segCtrl.tintColor = [UIColor grayColor];
    _segCtrl.selectedSegmentIndex = 0;
    [_segCtrl addTarget:self action:@selector(segChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segCtrl];
    [_segCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(44);
    }];
    
    _statisticTV = [[UITableView alloc]init];
    [self.view addSubview:_statisticTV];
    _statisticTV.backgroundColor = self.view.backgroundColor;
    UIView *view = [UIView new];
    view.backgroundColor = self.view.backgroundColor;
    _statisticTV.tableFooterView = view;
    [_statisticTV registerNib:[UINib nibWithNibName:@"SanyMainTableViewCell" bundle:nil] forCellReuseIdentifier:@"mainCell"];
    [_statisticTV registerNib:[UINib nibWithNibName:@"SanyChartTableViewCell" bundle:nil] forCellReuseIdentifier:@"chartCell"];
    _statisticTV.dataSource = self;
    _statisticTV.delegate = self;
    [_statisticTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_segCtrl.mas_bottom);
        make.bottom.mas_equalTo(-50);
        make.left.right.mas_equalTo(0);
    }];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_segCtrl.selectedSegmentIndex == 0) {
            [self staDataWithRefresh:YES];
        }else {
            [self alarmDataWithRefresh:YES];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"松手刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松手刷新数据" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"刷新完成" forState:MJRefreshStateWillRefresh];
    [header setTitle:@"刷新完成" forState:MJRefreshStateNoMoreData];
    _statisticTV.mj_header = header;
}

#pragma mark delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_segCtrl.selectedSegmentIndex == 0) {
        if (_sanyStaType == SanyStaTypeNone) {
            return 4;
        }else {
            return 6;
        }
    }else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        SanyChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chartCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell bindChartWithXLabels:_xLbs yValues:_yLbs];
        return cell;
    }else {
        SanyMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
        if (indexPath.row == 0 || indexPath.row >= 4) {
            cell.numbersLb.text = nil;
            cell.mainTitleLb.text = nil;
            cell.backgroundColor = self.view.backgroundColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if(_segCtrl.selectedSegmentIndex == 0){
            cell.backgroundColor = [UIColor whiteColor];
            cell.numbersLb.backgroundColor = [UIColor redColor];
            cell.numbersLb.textColor = [UIColor whiteColor];
            cell.numbersLb.text = [_timesAry[indexPath.row-1]description];
            cell.mainTitleLb.text = _timeTitleAry[indexPath.row-1];
        }else {
            cell.backgroundColor = [UIColor whiteColor];
            cell.numbersLb.backgroundColor = [UIColor redColor];
            cell.numbersLb.textColor = [UIColor whiteColor];
            cell.numbersLb.text = [_categorysAry[indexPath.row-1]description];
            cell.mainTitleLb.text = _categoryTitleAry[indexPath.row-1];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        return;
    }
    if (_segCtrl.selectedSegmentIndex == 1) {
        if (indexPath.row == 1) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [SANYRequestUtils sanyRequestBossAlarmByTypeWithStartTime:[SanyStaffUtil shareUtil].startTime endTime:[SanyStaffUtil shareUtil].endTime result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (error == nil) {
                    /*result = @{
                        @"rows": @[
                                 @{
                                     @"eiName": @"运输企业一",
                                     @"value": @2,
                                     @"label": @"GNSS天线未接或被剪断"
                                 },
                                 @{
                                     @"eiName": @"运输企业一",
                                     @"value": @51,
                                     @"label": @"出工地"
                                 },
                                 @{
                                     @"eiName": @"运输企业二",
                                     @"value": @12,
                                     @"label": @"重车偏航"
                                     },
                                 @{
                                     @"eiName": @"运输企业二",
                                     @"value": @91,
                                     @"label": @"闯禁"
                                     },
                                 @{
                                     @"eiName": @"运输企业二",
                                     @"value": @21,
                                     @"label": @"进工地"
                                     }
                                 ]
                        };*/
                    SanyStaListVC *listVC = [[SanyStaListVC alloc]init];
                    listVC.staTitle = @"报警类型统计";
                    listVC.mainTitle = @"报警类型";
                    listVC.subTitle = @"次数";
                    listVC.staData = [NSMutableDictionary dictionary];
                    NSArray *resultAry = result[@"rows"];
                    for (int i=0; i<resultAry.count; i++) {
                        NSDictionary *dic = resultAry[i];
                        [listVC.staData setObject:dic[@"value"] forKey:dic[@"label"]];
                    }
                    [self.navigationController pushViewController:listVC animated:YES];
                }else {
                    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                    [SVProgressHUD showErrorWithStatus:error.domain];
                }
            }];
        }else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [SANYRequestUtils sanyRequestBossAlarmByVechileWithStartTime:[SanyStaffUtil shareUtil].startTime endTime:[SanyStaffUtil shareUtil].endTime result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (error == nil) {
                    /// TODO: 后台没数据
                    /*result = @{
                        @"rows": @[
                                 @{
                                     @"eiName": @"运输企业一",
                                     @"value": @426,
                                     @"label": @"湘AL3U08"
                                 },
                                 @{
                                     @"eiName": @"运输企业一",
                                     @"value": @13,
                                     @"label": @"鄂A11111"
                                 },
                                 @{
                                     @"eiName": @"运输企业三",
                                     @"value": @1007,
                                     @"label": @"湘AZ0001"
                                 },
                                 @{
                                     @"eiName": @"运输企业二",
                                     @"value": @1364,
                                     @"label": @"湘AZ0002"
                                 }
                                 ]
                            };*/
                    SanyStaListVC *listVC = [[SanyStaListVC alloc]init];
                    listVC.staTitle = @"车辆报警统计";
                    listVC.mainTitle = @"车牌号";
                    listVC.subTitle = @"次数";
                    listVC.staData = [NSMutableDictionary dictionary];
                    NSArray *resultAry = result[@"rows"];
                    for (int i=0; i<resultAry.count; i++) {
                        NSDictionary *dic = resultAry[i];
                        [listVC.staData setObject:dic[@"value"] forKey:dic[@"label"]];
                    }
                    [self.navigationController pushViewController:listVC animated:YES];
                }else {
                    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                    [SVProgressHUD showErrorWithStatus:error.domain];
                }
            }];
        }
        
    }else {
        if (indexPath.row == 1) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [SANYRequestUtils sanyRequestBossVechileWithStartTime:[SanyStaffUtil shareUtil].startTime endTime:[SanyStaffUtil shareUtil].endTime result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (error == nil) {
                    SanyStaListVC *listVC = [[SanyStaListVC alloc]init];
                    listVC.staTitle = @"当日趟次列表";
                    listVC.mainTitle = @"车牌号";
                    listVC.subTitle = @"趟次";
                    listVC.staData = [NSMutableDictionary dictionary];
                    
                    NSArray *resultAry = result[@"rows"];
                    for (int i=0; i<resultAry.count; i++) {
                        NSDictionary *dic = resultAry[i];
                        [listVC.staData setObject:dic[@"times"] forKey:dic[@"ev_vehiNO"]];
                    }
                    [self.navigationController pushViewController:listVC animated:YES];
                }else {
                    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                    [SVProgressHUD showErrorWithStatus:error.domain];
                }
            }];
            
        }else if (indexPath.row == 2) {
            if (_sanyStaType == SanyStaTypeMonth) {
                _sanyStaType = SanyStaTypeNone;
                [_statisticTV reloadData];
            }else {
                _sanyStaType = SanyStaTypeMonth;
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [SANYRequestUtils sanyRequestBossDayCountWithStartTime:[SanyStaffUtil shareUtil].startTime endTime:[SanyStaffUtil shareUtil].endTime result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (error == nil) {
                        _xLbs = [NSMutableArray array];
                        _yLbs = [NSMutableArray array];
                        NSArray *resultAry = result[@"rows"];
                        for (int i=0; i<resultAry.count; i++) {
                            NSDictionary *dic = resultAry[i];
                            [_xLbs addObject:dic[@"gpsDay"]];
                            [_yLbs addObject:dic[@"times"]];
                        }
                        [_statisticTV reloadData];
                    }else {
                        [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                        [SVProgressHUD showErrorWithStatus:error.domain];
                    }
                }];
            }

        }else if(indexPath.row == 3){
            if (_sanyStaType == SanyStaTypeYear) {
                _sanyStaType = SanyStaTypeNone;
                [_statisticTV reloadData];
            }else {
                _sanyStaType = SanyStaTypeYear;
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [SANYRequestUtils sanyRequestBossMonthCountWithStartTime:[SanyStaffUtil shareUtil].startTime endTime:[SanyStaffUtil shareUtil].endTime result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (error == nil) {
                        _xLbs = [NSMutableArray array];
                        _yLbs = [NSMutableArray array];
                        NSArray *resultAry = result[@"rows"];
                        for (int i=0; i<resultAry.count; i++) {
                            NSDictionary *dic = resultAry[i];
                            [_xLbs addObject:dic[@"gpsMonth"]];
                            [_yLbs addObject:dic[@"times"]];
                        }
                        [_statisticTV reloadData];
                    }else {
                        [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                        [SVProgressHUD showErrorWithStatus:error.domain];
                    }
                }];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        return 200.0f;
    }else {
        return 44.0f;
    }
}

#pragma mark private
- (void)segChanged:(UISegmentedControl *)segCtrl {
    if (segCtrl.selectedSegmentIndex == 0) {
        [self staDataWithRefresh:NO];
    }else {
        [self alarmDataWithRefresh:NO];
    }
}










@end
