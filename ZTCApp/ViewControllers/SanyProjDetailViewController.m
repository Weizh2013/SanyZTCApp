//
//  SanyProjDetailViewController.m
//  ZTCApp
//
//  Created by 魏宙辉 on 17/1/17.
//  Copyright © 2017年 Sany. All rights reserved.
//

#import "SanyProjDetailViewController.h"
#import "CheckProVehiViewController.h"
#import "CheckRouteMapViewController.h"
#import "Masonry.h"

@interface SanyProjDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    // 工程详情展示
    UITableView *_projDetailTableView;
    // 通过按键
    UIButton *_passButton;
    // 驳回按键
    UIButton *_rejectButton;
}

- (void)viewInit;
- (void)buttonClicked:(UIButton *)sender;

@end

@implementation SanyProjDetailViewController

#pragma mark - private
/**
 *  视图加载完毕
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
}

/**
 *  视图将要显示
 *
 *  @param animated 是否动画展示
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 底部tabBar栏隐藏
    self.tabBarController.tabBar.hidden = YES;
}

/**
 *  视图将要消失
 *
 *  @param animated 是否动画展示
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 取消底部tabBar栏隐藏
    self.tabBarController.tabBar.hidden = NO;
}

/**
 *  视图初始化
 */
- (void)viewInit {
    // 导航栏显示初始化
    self.navigationItem.title = @"工程详情";
    // 工程详情显示初始化
    self.automaticallyAdjustsScrollViewInsets = NO;
    _projDetailTableView = [[UITableView alloc] init];
    [self.view addSubview:_projDetailTableView];
    [_projDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(-44);
        make.left.right.mas_equalTo(0);
    }];
    [_projDetailTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"detailCell"];
    _projDetailTableView.dataSource = self;
    _projDetailTableView.delegate = self;
    //    NSLog(@"Info:%@", self.projInfo);
    // 通过和驳回按键初始化
    _passButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _passButton.backgroundColor = [UIColor greenColor];
    [_passButton setTitle:@"通过" forState:UIControlStateNormal];
    [_passButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_passButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _rejectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _rejectButton.backgroundColor = [UIColor redColor];
    [_rejectButton setTitle:@"驳回" forState:UIControlStateNormal];
    [_rejectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rejectButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_passButton];
    [self.view addSubview:_rejectButton];
    [_passButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_projDetailTableView.mas_bottom);
        make.left.bottom.mas_offset(0);
        make.right.equalTo(_projDetailTableView.mas_centerX);
    }];
    [_rejectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_passButton);
        make.left.equalTo(_passButton.mas_right);
        make.right.mas_equalTo(0);
    }];
}

/**
 *  通过和驳回按键处理
 *
 *  @param sender 通过和驳回按键对象
 */
- (void)buttonClicked:(UIButton *)sender {
    if ([sender isEqual:_passButton]) {
        [SANYRequestUtils agreeProjectWithPiId:self.projInfo[@"piId"]
                                        result:^(NSDictionary *_Nullable result, NSError *_Nullable error) {
                                            if (error == nil) {
                                                NSLog(@"result:%@", result[@"msg"]);
                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                            } else {
                                                [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                                                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                                [SVProgressHUD showErrorWithStatus:error.domain];
                                            }
                                        }];
    } else if ([sender isEqual:_rejectButton]) {
        [SANYRequestUtils rejectProjectWithPiId:self.projInfo[@"piId"]
                                         result:^(NSDictionary *_Nullable result, NSError *_Nullable error) {
                                             if (error == nil) {
                                                 NSLog(@"result:%@", result[@"msg"]);
                                                 [self.navigationController popToRootViewControllerAnimated:YES];
                                             } else {
                                                 [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                                                 [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                                 [SVProgressHUD showErrorWithStatus:error.domain];
                                             }
                                         }];
    } else {
        // 保留
    }
}

#pragma mark - delegate
/**
 *  返回tableview行数的代理方法
 *
 *  @param tableView 当前tableview参数值
 *  @param section   当前section参数值
 *
 *  @return 返回tableview行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

/**
 *  返回每个cell的内容及视图
 *
 *  @param tableView 当前tableview参数值
 *  @param indexPath 当前indexPath参数值
 *
 *  @return 返回UITableViewCell对象指针
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.text = [NSString stringWithFormat:@"工程名称:%@", self.projInfo[@"piName"]];
            break;
        case 1:
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.text = [NSString stringWithFormat:@"工地名称:%@", self.projInfo[@"efName"]];
            break;
        case 2:
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.text = [NSString stringWithFormat:@"消纳厂:%@", self.projInfo[@"piConsField"]];
            break;
        case 3:
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.text = [NSString stringWithFormat:@"运输公司:%@", self.projInfo[@"piTranUnitName"]];
            break;
        case 4:
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.text = [NSString stringWithFormat:@"施工单位:%@", self.projInfo[@"piConsUnitName"]];
            break;
        case 5:
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.text = [NSString stringWithFormat:@"开始时间:%@", self.projInfo[@"piStartTime"]];
            break;
        case 6:
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.text = [NSString stringWithFormat:@"结束时间:%@", self.projInfo[@"piEndTime"]];
            break;
        case 7:
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.text = [NSString stringWithFormat:@"准运时间:%@ -> %@", self.projInfo[@"piShipStartTime"], self.projInfo[@"piShipEndTime"]];
            break;
        case 8:
            cell.textLabel.textColor = [UIColor blueColor];
            cell.textLabel.text = @"运行车辆";
            break;
        case 9:
            cell.textLabel.textColor = [UIColor blueColor];
            cell.textLabel.text = @"路线查看";
            break;
        default:
            cell.textLabel.text = @"待定";
            break;
    }
    return cell;
}

/**
 *  tableview选择某个cell后的操作
 *
 *  @param tableView 当前tableview参数值
 *  @param indexPath 当前indexPath参数值
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 8) {
        [SANYRequestUtils projectVehiWithPiId:self.projInfo[@"piId"]
                                       result:^(NSDictionary *_Nullable result, NSError *_Nullable error) {
                                           if (error == nil) {
                                               CheckProVehiViewController *vehiListViewController = [[CheckProVehiViewController alloc] init];
                                               vehiListViewController.vehiArray = result[@"rows"];
                                               /*
                                               vehiListViewController.vehiArray = @[ @{
                                                                                        @"evVehiNo" : @"湘AG2W63",
                                                                                        @"eiName" : @"运输公司1",
                                                                                        @"sfName" : @"魏宙辉"
                                                                                    },
                                                                                     @{
                                                                                         @"evVehiNo" : @"湘AG2W63",
                                                                                         @"eiName" : @"运输公司2",
                                                                                         @"sfName" : @"魏辉"
                                                                                     },
                                                                                     @{
                                                                                         @"evVehiNo" : @"湘AG2W63",
                                                                                         @"eiName" : @"运输公司3",
                                                                                         @"sfName" : @"宙辉"
                                                                                     } ];
                                                */
                                               [self.navigationController pushViewController:vehiListViewController animated:YES];
                                           } else {
                                               [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                                               [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                               [SVProgressHUD showErrorWithStatus:error.domain];
                                           }
                                       }];
    } else if (indexPath.row == 9) {
        [SANYRequestUtils projectRouteWithPiId:self.projInfo[@"piId"]
                                        result:^(NSDictionary *_Nullable result, NSError *_Nullable error) {
                                            if (error == nil) {
                                                CheckRouteMapViewController *routeMapViewController = [[CheckRouteMapViewController alloc] init];
                                                routeMapViewController.routeArray = (NSArray *) result;
                                                routeMapViewController.piId = self.projInfo[@"piWorkSite"];
                                                [self.navigationController pushViewController:routeMapViewController animated:YES];
                                            } else {
                                                [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
                                                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                                [SVProgressHUD showErrorWithStatus:error.domain];
                                            }
                                        }];
    }
}

@end
