//
//  SanyBossMainVC.m
//  ZTCApp
//
//  Created by zousj on 16/6/30.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyBossMainVC.h"
#import "SanyMainTableViewCell.h"
#import "SanyWorkSiteInfo.h"
#import "SanyListVC.h"
#import "SanyAlarmListVC.h"
#import "Masonry.h"

@interface SanyBossMainVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_mainTV;
    NSArray     *_titleAry;
    NSArray     *_numAry;
    NSArray     *_projects;
}
@end

@implementation SanyBossMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
    [self dataWithRefresh:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma initialize
- (void)viewInit {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"首页";
    _mainTV = [[UITableView alloc]init];
    [self.view addSubview:_mainTV];
    _mainTV.backgroundColor = self.view.backgroundColor;
    UIView *view = [UIView new];
    view.backgroundColor = self.view.backgroundColor;
    _mainTV.tableFooterView = view;
    [_mainTV registerNib:[UINib nibWithNibName:@"SanyMainTableViewCell" bundle:nil] forCellReuseIdentifier:@"mainCell"];
    _mainTV.dataSource = self;
    _mainTV.delegate = self;
    [_mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(-50);
        make.left.right.mas_equalTo(0);
    }];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self dataWithRefresh:YES];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"松手刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松手刷新数据" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"刷新完成" forState:MJRefreshStateWillRefresh];
    [header setTitle:@"刷新完成" forState:MJRefreshStateNoMoreData];
    _mainTV.mj_header = header;
}

- (void)dataWithRefresh:(BOOL)isRefresh {
    if (!isRefresh) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [SANYRequestUtils sanyRequestBossMainWithStartTime:[SanyStaffUtil shareUtil].startTime endTime:[SanyStaffUtil shareUtil].endTime result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        if (isRefresh) {
            [_mainTV.mj_header endRefreshing];
        }else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        if (error == nil) {
            NSNumber *n0,*n1;
            NSArray *resultAry = result[@"rows"];
            for (int i=0; i<resultAry.count; i++) {
                NSDictionary *dic = resultAry[i];
                if ([dic[@"label"]isEqualToString:@"开工车辆"]) {
                    n0 = dic[@"value"];
                }else if([dic[@"label"]isEqualToString:@"报警总数"]) {
                    n1 = dic[@"value"];
                }
            }
            _numAry = @[n0,n1];
            [_mainTV reloadData];
        }else {
            [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
    _titleAry = @[@"运营车辆",@"报警车辆"];
    
    [SANYRequestUtils sanyProInfoResult:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        if (error == nil) {
            NSArray *resultAry = result[@"rows"];
            if ([[resultAry firstObject]isKindOfClass:[NSDictionary class]]) {
                _projects = resultAry;
                [_mainTV reloadData];
            }
        }else {
            [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

#pragma delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else {
        return _projects.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SanyMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.numbersLb.hidden = NO;
        cell.backgroundColor = [UIColor whiteColor];
        cell.numbersLb.backgroundColor = [UIColor redColor];
        cell.numbersLb.textColor = [UIColor whiteColor];
        cell.numbersLb.text = [_numAry[indexPath.row]description];
        cell.mainTitleLb.text = _titleAry[indexPath.row];
    }else {
        cell.numbersLb.hidden = YES;
        cell.mainTitleLb.text = _projects[indexPath.row][@"pi_name"];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            SanyListVC *listVC = [[SanyListVC alloc]init];
            listVC.sanyListType = SanyInfoTypeCar;
            [self.navigationController pushViewController:listVC animated:YES];
        }else {
            SanyAlarmListVC *listVC = [[SanyAlarmListVC alloc]init];
            [self.navigationController pushViewController:listVC animated:YES];
        }
        
    }else if (indexPath.section == 1) {
        SanyWorkSiteInfo *worksiteInfo = [[SanyWorkSiteInfo alloc]init];
        worksiteInfo.worksiteInfo = _projects[indexPath.row];
        [self.navigationController pushViewController:worksiteInfo animated:YES];
    }
    
}

@end












