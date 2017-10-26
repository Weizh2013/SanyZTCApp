//
//  SanyManagerStatisticVC.m
//  ZTCApp
//
//  Created by zousj on 16/6/28.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyManagerStatisticVC.h"
#import "Masonry.h"
#import "SanyAlarmTableViewCell.h"

@interface SanyManagerStatisticVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray* _staAry;
    UITableView* _staTV;
}
@end

@implementation SanyManagerStatisticVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
    [self dataUpdateRefresh:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma initilize
- (void)dataUpdateRefresh:(BOOL)isRefresh {
    if (isRefresh == NO) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [SANYRequestUtils sanyRequestCountWithStartTime:[SanyStaffUtil shareUtil].startTime
                                            endTime:[SanyStaffUtil shareUtil].endTime
                                             result:^(NSDictionary* _Nullable result, NSError* _Nullable error) {
                                                 if (isRefresh) {
                                                     [_staTV.mj_header endRefreshing];
                                                 } else {
                                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                 }
                                                 if (error == nil) {
                                                     BOOL flag = NO;
                                                     _staAry = [NSMutableArray array];
                                                     NSArray* rows = result[@"rows"];
                                                     for (NSDictionary* dic in rows) {
                                                         NSMutableDictionary* mutDic = [NSMutableDictionary dictionary];
                                                         [mutDic setObject:[dic[@"eiName"] description] forKey:@"eiName"];
                                                         for (NSMutableDictionary* staDic in _staAry) {
                                                             if ([[staDic[@"eiName"] description] isEqualToString:[dic[@"eiName"] description]]) {
                                                                 mutDic = staDic; // 之前创建过就覆盖
                                                                 flag = YES;
                                                             }
                                                         }
                                                         if (!flag) {
                                                             [_staAry addObject:mutDic];
                                                         }
                                                         flag = NO;
                                                         [mutDic setObject:dic[@"value"] forKey:[dic[@"label"] description]];
                                                     }
                                                     [_staTV reloadData];
                                                 } else {
                                                     [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                                                     [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                                     [SVProgressHUD showErrorWithStatus:error.domain];
                                                 }
                                             }];
}
- (void)viewInit {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"统计分析";
    _staTV = [[UITableView alloc] init];
    [self.view addSubview:_staTV];
    [_staTV mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(64);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
    _staTV.backgroundColor = self.view.backgroundColor;
    _staTV.allowsSelection = NO;
    [_staTV registerClass:[SanyAlarmTableViewCell class] forCellReuseIdentifier:@"alarmCell"];
    _staTV.dataSource = self;
    _staTV.delegate = self;
    UIView* view = [UIView new];
    view.backgroundColor = self.view.backgroundColor;
    _staTV.tableFooterView = view;

    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self dataUpdateRefresh:YES];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"松手刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松手刷新数据" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"刷新完成" forState:MJRefreshStateWillRefresh];
    [header setTitle:@"刷新完成" forState:MJRefreshStateNoMoreData];
    _staTV.mj_header = header;
}

#pragma delegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return _staAry.count + 1;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    SanyAlarmTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"alarmCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell clearCell];
        cell.backgroundColor = self.view.backgroundColor;
    } else {
        [cell reloadDataWithDic:_staAry[indexPath.row - 1]];
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row == 0) {
        return 44.0f;
    } else {
        NSDictionary* dic = _staAry[indexPath.row - 1];
        return 5.0f + dic.allKeys.count * 30.0f;
    }
}

@end
