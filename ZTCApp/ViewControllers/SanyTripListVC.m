//
//  SanyTripListVC.m
//  ZTCApp
//
//  Created by zousj on 16/7/1.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyTripListVC.h"
#import "SanyTripTableViewCell.h"
#import "Masonry.h"

@interface SanyTripListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_staTabView;
}
@end

@implementation SanyTripListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark initilize

- (void)viewInit {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"趟次列表";
    _staTabView = [[UITableView alloc]init];
    [self.view addSubview:_staTabView];
    [_staTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.bottom.left.right.mas_equalTo(0);
    }];
    [_staTabView registerNib:[UINib nibWithNibName:@"SanyTripTableViewCell" bundle:nil] forCellReuseIdentifier:@"tripCell"];
    _staTabView.dataSource = self;
    _staTabView.delegate = self;
    _staTabView.backgroundColor = self.view.backgroundColor;
    UIView *view = [UIView new];
    view.backgroundColor = self.view.backgroundColor;
    _staTabView.tableFooterView = view;
    _staTabView.allowsSelection = NO;
}

#pragma mark delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tripAry.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SanyTripTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tripCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.backgroundColor = self.view.backgroundColor;
        cell.plantTitleLb.text = nil;
        cell.outletTitleLb.text = nil;
        cell.timeTitleLb.text = nil;
        cell.plantNameLb.text = nil;
        cell.outletNameLb.text = nil;
        cell.timeLb.text = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else {
        cell.backgroundColor = [UIColor whiteColor];
        NSDictionary *dic = _tripAry[indexPath.row-1];
        [cell bindCellWithPlant:dic[@"workSiteName"] outlet:dic[@"consFieldName"] time:dic[@"gpsTime"]];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 44.0f;
    }else {
        return 95.0f;
    }
}

@end
