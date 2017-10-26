//
//  SanyListVC.m
//  ZTCApp
//
//  Created by zousj on 16/6/29.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyListVC.h"
#import "SanyListTableViewCell.h"
#import "Masonry.h"
#import "SanyMapVC.h"

@interface SanyListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView     *_listTV;
    NSArray         *_listAry;
    NSString        *_listTitle;
}
@end

@implementation SanyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataWithRefresh:NO];
    [self viewInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma initilize
- (void)dataWithRefresh:(BOOL)isRefresh {
    if (!isRefresh) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [SANYRequestUtils sanyRequestListInfoWithStartTime:[SanyStaffUtil shareUtil].startTime endTime:[SanyStaffUtil shareUtil].endTime type:_sanyListType result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        if (isRefresh) {
            [_listTV.mj_header endRefreshing];
        }else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        if (error == nil) {
            _listAry = result[@"rows"];
            [_listTV reloadData];
        }else {
            [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
    
    switch (_sanyListType) {
        case SanyInfoTypeSite:{
            _listTitle = @"工地列表";
            break;
        }
        case SanyInfoTypeConsumField:{
            _listTitle = @"消纳厂列表";
            break;
        }
        case SanyInfoTypeCar:{
            _listTitle = @"运营车辆列表";
            break;
        }
        case SanyInfoTypeDriver:{
            _listTitle = @"运营车辆列表";
            break;
        }
        default:
            break;
    }
}
- (void)viewInit {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = _listTitle;
    _listTV = [[UITableView alloc]init];
    _listTV.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_listTV];
    [_listTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.bottom.right.mas_equalTo(0);
    }];
    _listTV.dataSource = self;
    _listTV.delegate = self;
    [_listTV registerNib:[UINib nibWithNibName:@"SanyListTableViewCell" bundle:nil] forCellReuseIdentifier:@"SanyListCell"];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = self.view.backgroundColor;
    _listTV.tableFooterView = view;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self dataWithRefresh:YES];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"松手刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松手刷新数据" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"刷新完成" forState:MJRefreshStateWillRefresh];
    [header setTitle:@"刷新完成" forState:MJRefreshStateNoMoreData];
    _listTV.mj_header = header;
}

#pragma delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listAry.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SanyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SanyListCell" forIndexPath:indexPath];
    cell.positionLb.hidden = YES;
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.nameLb.text = nil;
        cell.placeLb.text = nil;
        cell.backgroundColor = self.view.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }/*else if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.nameLb.text = _firstCellTitle1;
        cell.placeLb.text = _firstCellTitle2;
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }*/else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (_sanyListType) {
            case SanyInfoTypeCar:
                cell.nameLb.text = [_listAry[indexPath.row-1][@"ev_vehiNo"]description];
                cell.placeLb.text = [_listAry[indexPath.row-1][@"sfName"]description];
                break;
            case SanyInfoTypeSite:
                cell.nameLb.text = [_listAry[indexPath.row-1][@"siteName"]description];
                cell.placeLb.text = [_listAry[indexPath.row-1][@"efAreaName"]description];
                break;
            case SanyInfoTypeConsumField:
                cell.nameLb.text = [_listAry[indexPath.row-1][@"consumName"]description];
                cell.placeLb.text = [_listAry[indexPath.row-1][@"efAreaName"]description];
                break;
            default:
                /// TODO: 司机数据处理
                cell.nameLb.text =@"司机预留";
                cell.placeLb.text =@"司机预留";
                break;
        }
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row > 0) {
        SanyMapVC *mapVC = [[SanyMapVC alloc]init];
        switch (_sanyListType) {
            case SanyInfoTypeCar:
                mapVC.mapTitle = [_listAry[indexPath.row-1][@"ev_vehiNo"]description];
                return;
                break;
            case SanyInfoTypeSite:
                mapVC.mapTitle = [_listAry[indexPath.row-1][@"siteName"]description];
                break;
            case SanyInfoTypeConsumField:
                mapVC.mapTitle = [_listAry[indexPath.row-1][@"consumName"]description];
                break;
            default:
                /// TODO: 司机数据处理
                mapVC.mapTitle =@"司机预留";
                break;
        }
        mapVC.type       = _sanyListType;
        mapVC.mapInfo    = _listAry[indexPath.row-1];
        [self.navigationController pushViewController:mapVC animated:YES];
    }
}

@end
