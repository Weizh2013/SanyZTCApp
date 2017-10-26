//
//  SanyAlarmListVC.m
//  ZTCApp
//
//  Created by zousj on 16/6/30.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyAlarmListVC.h"
#import "SanyStaBomTableViewCell.h"
#import "Masonry.h"

@interface SanyAlarmListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray     *_staAry;
    UITableView *_staTV;
}
@end

@implementation SanyAlarmListVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma initilize
- (void)dataInit {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SANYRequestUtils sanyRequestAlarmStartTime:[SanyStaffUtil shareUtil].startTime endTime:[SanyStaffUtil shareUtil].endTime result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (result != nil) {
            _staAry = result[@"rows"];
            [_staTV reloadData];
        }else {
            [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}
- (void)viewInit {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"报警车辆列表";
    _staTV = [[UITableView alloc]init];
    [self.view addSubview:_staTV];
    [_staTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.bottom.right.mas_equalTo(0);
    }];
    _staTV.backgroundColor = self.view.backgroundColor;
    _staTV.allowsSelection = NO;
    [_staTV registerNib:[UINib nibWithNibName:@"SanyStaBomTableViewCell" bundle:nil] forCellReuseIdentifier:@"StaBomCell"];
    _staTV.dataSource = self;
    _staTV.delegate = self;
    UIView *view = [UIView new];
    view.backgroundColor = self.view.backgroundColor;
    _staTV.tableFooterView = view;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        /// TODO: 重新刷新请求网络，并重新加载页面
        [_staTV.mj_header performSelector:@selector(endRefreshing) withObject:nil afterDelay:3.0f];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _staAry.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SanyStaBomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StaBomCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell clearCell];
        cell.backgroundColor = self.view.backgroundColor;
    }else {
        [cell reloadDataWithAlarmDic:_staAry[indexPath.row-1]];
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 44.0f;
    }else {
        return 125.0f;
    }
}












@end
