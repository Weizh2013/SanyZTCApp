//
//  SanyManagerMainVC.m
//  ZTCApp
//
//  Created by zousj on 16/6/28.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyManagerMainVC.h"
#import "Masonry.h"
#import "SanyListVC.h"
#import "SanyMainTableViewCell.h"
#import "SanyAlarmListViewController.h"

@interface SanyManagerMainVC ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_mainTV;
    NSArray *_titleAry;
    NSArray *_numberAry;
    NSNumber *_unlaws; // 待处理违法数
}
@end

@implementation SanyManagerMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataUpdateRefresh:NO];
    [self viewInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma Initialize
- (void)dataUpdateRefresh:(BOOL)isRefresh {
    __block NSNumber *n0, *n1, *n2, *n3, *n4, *n5;
    n0 = @0;
    n1 = @0;
    n2 = @0;
    n3 = @0;
    n4 = @0;
    n5 = @0;
    if (isRefresh == NO) {
        _titleAry = @[
            @"工地总数", @"开工工地", @"总数", @"可用消纳厂",
            @"总数", @"试行车辆"
        ];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [SANYRequestUtils sanyRequestMainWithStartTime:[SanyStaffUtil shareUtil].startTime
                                           endTime:[SanyStaffUtil shareUtil].endTime
                                            result:^(NSDictionary *_Nullable result,
                                                     NSError *_Nullable error) {
                                                if (isRefresh) {
                                                    [_mainTV.mj_header endRefreshing];
                                                } else {
                                                    [MBProgressHUD hideHUDForView:self.view
                                                                         animated:YES];
                                                }
                                                if (error == nil) {
                                                    NSArray *resultAry = result[@"rows"];
                                                    for (int i = 0; i < resultAry.count; i++) {
                                                        NSDictionary *dic = resultAry[i];
                                                        if ([dic[@"label"] isEqualToString:@"开工车辆"]) {
                                                            n5 = dic[@"value"];
                                                        } else if ([dic[@"label"] isEqualToString:@"开工工地"]) {
                                                            n1 = dic[@"value"];
                                                        } else if ([dic[@"label"] isEqualToString:@"开工消纳场"]) {
                                                            n3 = dic[@"value"];
                                                        } else if ([dic[@"label"] isEqualToString:@"vehicleCount"]) {
                                                            n4 = dic[@"value"];
                                                        } else if ([dic[@"label"] isEqualToString:@"siteCount"]) {
                                                            n0 = dic[@"value"];
                                                        } else if ([dic[@"label"] isEqualToString:@"consumFieldCount"]) {
                                                            n2 = dic[@"value"];
                                                        }
                                                    }
                                                    _numberAry = @[ n0, n1, n2, n3, n4, n5 ];
                                                    [_mainTV reloadData];
                                                } else {
                                                    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                                                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                                    [SVProgressHUD showErrorWithStatus:error.domain];
                                                }
                                            }];

    if ([SanyStaffUtil shareUtil].isExer == YES) {
        [SANYRequestUtils sanyGetAlarmCountByStaffId:[SanyStaffUtil shareUtil].staffId
                                              result:^(NSDictionary *_Nullable result, NSError *_Nullable error) {
                                                  if (error == nil) {
                                                      _unlaws = [result[@"rows"] firstObject][@"count"];
                                                      [_mainTV reloadData];
                                                  } else {
                                                      [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                                                      [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                                      [SVProgressHUD showErrorWithStatus:error.domain];
                                                  }
                                              }];
    }
}

- (void)viewInit {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"首页";
    _mainTV = [[UITableView alloc] init];
    [self.view addSubview:_mainTV];
    [_mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(-50);
        make.left.right.mas_equalTo(0);
    }];
    _mainTV.dataSource = self;
    _mainTV.delegate = self;
    [_mainTV registerNib:[UINib nibWithNibName:@"SanyMainTableViewCell"
                                        bundle:nil]
        forCellReuseIdentifier:@"mainCell"];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = self.view.backgroundColor;
    _mainTV.tableFooterView = view;
    _mainTV.backgroundColor = self.view.backgroundColor;

    MJRefreshNormalHeader *header =
        [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self dataUpdateRefresh:YES];
        }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"松手刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松手刷新数据" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"刷新完成" forState:MJRefreshStateWillRefresh];
    [header setTitle:@"刷新完成" forState:MJRefreshStateNoMoreData];
    _mainTV.mj_header = header;
}

#pragma delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([SanyStaffUtil shareUtil].isExer == YES) {
        return 4;
    }
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
    if ([SanyStaffUtil shareUtil].isExer == YES && section == 3) {
        return 1;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SanyMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"
                                                                  forIndexPath:indexPath];
    if ([SanyStaffUtil shareUtil].isExer == YES && indexPath.section == 3) {
        cell.numbersLb.backgroundColor = [UIColor redColor];
        cell.numbersLb.textColor = [UIColor whiteColor];
        cell.mainTitleLb.text = @"待处理违法";
        cell.numbersLb.text = _unlaws.description;
        return cell;
    }
    if (indexPath.row % 2 == 0) {
        cell.numbersLb.backgroundColor = [UIColor clearColor];
        cell.numbersLb.textColor = [UIColor grayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.numbersLb.backgroundColor = [UIColor redColor];
        cell.numbersLb.textColor = [UIColor whiteColor];
    }
    cell.mainTitleLb.text = _titleAry[indexPath.section * 2 + indexPath.row];
    cell.numbersLb.text = [_numberAry[indexPath.section * 2 + indexPath.row] description];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
    if ([SanyStaffUtil shareUtil].isExer == YES && section == 3) {
        return 55.0f;
    }
    return 44.0f;
}
- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"工地";
            break;
        case 1:
            return @"消纳厂";
            break;
        case 2:
            return @"运营车辆";
            break;
        default:
            return @"";
            break;
    }
}
- (void)tableView:(UITableView *)tableView
    willDisplayHeaderView:(UIView *)view
               forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *) view;
    headerView.textLabel.textColor = [UIColor grayColor];
}
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([SanyStaffUtil shareUtil].isExer == YES && indexPath.section == 3) {
        SanyAlarmListViewController *alarmListViewController = [[SanyAlarmListViewController alloc]init];
        [self.navigationController pushViewController:alarmListViewController animated:YES];
    } else if (indexPath.row % 2) {
        SanyListVC *listVC = [[SanyListVC alloc] init];
        switch (indexPath.section) {
            case 0:
                listVC.sanyListType = SanyInfoTypeSite;
                break;
            case 1:
                listVC.sanyListType = SanyInfoTypeConsumField;
                break;
            default:
                listVC.sanyListType = SanyInfoTypeCar;
                break;
        }
        [self.navigationController pushViewController:listVC animated:YES];
    }
}

@end
