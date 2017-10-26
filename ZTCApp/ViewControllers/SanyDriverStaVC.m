//
//  SanyDriverStaVC.m
//  ZTCApp
//
//  Created by zousj on 16/7/1.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyDriverStaVC.h"
#import "SanyMainTableViewCell.h"
#import "SanyChartTableViewCell.h"
#import "SanyTripListVC.h"
#import "Masonry.h"

typedef NS_ENUM(NSInteger, SanyStaType) {
    SanyStaTypeNone     =  0,    // 不显示柱状图
    SanyStaTypeMonth    =  1,    // 显示月趟次柱状图
    SanyStaTypeYear     =  2,    // 显示年趟次柱状图
};

@interface SanyDriverStaVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView         *_statisticTV;
    NSArray             *_timeTitleAry;
    NSArray             *_timesAry;
    NSMutableArray      *_xLbs;
    NSMutableArray      *_yLbs;
    
    SanyStaType         _sanyStaType;
}
@end

@implementation SanyDriverStaVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self dataInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark initilize
- (void)dataInit {
    _sanyStaType    = SanyStaTypeNone;         // 默认不显示
    _timeTitleAry   = @[@"当日趟次",@"当月趟次",@"当年趟次"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SANYRequestUtils sanyTripTimesWith:[SanyStaffUtil shareUtil].startTime endTime:[SanyStaffUtil shareUtil].endTime result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error == nil) {
            NSString *dayTimes = nil, *monthTimes = nil, *yearTimes = nil;
            for (NSDictionary *dic in result[@"rows"]) {
                if ([dic[@"label"]isEqualToString:_timeTitleAry[0]]) {
                    dayTimes = dic[@"value"];
                }else if ([dic[@"label"]isEqualToString:_timeTitleAry[1]]) {
                    monthTimes = dic[@"value"];
                }else if ([dic[@"label"]isEqualToString:_timeTitleAry[2]]) {
                    yearTimes = dic[@"value"];
                }else {
                    NSLog(@"can't find the label");
                }
            }
            _timesAry = @[dayTimes, monthTimes, yearTimes];
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
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(-50);
        make.left.right.mas_equalTo(0);
    }];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        /// TODO: 重新刷新请求网络，并重新加载页面
        [_statisticTV.mj_header performSelector:@selector(endRefreshing) withObject:nil afterDelay:3.0f];
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
    if (_sanyStaType == SanyStaTypeNone) {
        return 4;
    }else {
        return 6;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        SanyChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chartCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
/*
        /// TODO: 显示网络数据
        NSArray *xLbs, *yLbs;
        if (_sanyStaType == SanyStaTypeMonth) {
            NSLog(@"月趟次表");
            xLbs = @[@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"];
            yLbs = @[@15,@10,@18,@16,@15,@12,@9,@10,@8,@17,@11];
        }else if (_sanyStaType == SanyStaTypeYear) {
            NSLog(@"年趟次表");
            xLbs = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
            yLbs = @[@200,@120,@180,@116,@125,@128,@99,@130,@281,@276,@110,@153];
        }
*/
        [cell bindChartWithXLabels:_xLbs yValues:_yLbs];
        return cell;
    }else {
        SanyMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
        if (indexPath.row == 0 || indexPath.row >= 4) {
            cell.numbersLb.text = nil;
            cell.mainTitleLb.text = nil;
            if (indexPath.row == 0) {
                cell.mainTitleLb.text = @"运行趟数统计";
                cell.mainTitleLb.textColor = [UIColor grayColor];
            }
            cell.backgroundColor = self.view.backgroundColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            cell.backgroundColor = [UIColor whiteColor];
            cell.numbersLb.backgroundColor = [UIColor redColor];
            cell.numbersLb.textColor = [UIColor whiteColor];
            cell.numbersLb.text = _timesAry[indexPath.row-1];
            cell.mainTitleLb.text = _timeTitleAry[indexPath.row-1];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        return;
    }
    if (indexPath.row == 1) {
        [SANYRequestUtils sanyDayTimesWith:[SanyStaffUtil shareUtil].startTime endTime:[SanyStaffUtil shareUtil].endTime result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
            if (error == nil) {
                SanyTripListVC *listVC = [[SanyTripListVC alloc]init];
                listVC.tripAry = result[@"rows"];
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
            [SANYRequestUtils sanyMonthTimesWith:[SanyStaffUtil shareUtil].startTime endTime:[SanyStaffUtil shareUtil].endTime result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
                if (error == nil) {
                    _xLbs = [NSMutableArray array];
                    _yLbs = [NSMutableArray array];
                    NSArray *tmpAry = result[@"rows"];
                    for (int i=0; i<tmpAry.count; i++) {
                        NSDictionary *dic = tmpAry[i];
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
            [SANYRequestUtils sanyYearTimesWith:[SanyStaffUtil shareUtil].startTime endTime:[SanyStaffUtil shareUtil].endTime result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
                if (error == nil) {
                    _xLbs = [NSMutableArray array];
                    _yLbs = [NSMutableArray array];
                    NSArray *tmpAry = result[@"rows"];
                    for (int i=0; i<tmpAry.count; i++) {
                        NSDictionary *dic = tmpAry[i];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        return 200.0f;
    }else {
        return 44.0f;
    }
}


@end
