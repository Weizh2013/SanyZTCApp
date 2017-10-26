//
//  SanyAlarmListViewController.m
//  ZTCApp
//
//  Created by 魏宙辉 on 17/1/22.
//  Copyright © 2017年 Sany. All rights reserved.
//

#import "SanyAlarmListViewController.h"
#import "SanyAlarmDetailViewController.h"

@interface SanyAlarmListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_alarmList;
    
    NSArray     *_alarmArray;
}
@end

@implementation SanyAlarmListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
    [self dataInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewInit {
    self.navigationItem.title = @"违法列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _alarmList = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetMaxX(self.view.bounds), CGRectGetMaxY(self.view.bounds)-64.0) style:UITableViewStylePlain];
    [_alarmList registerClass:[UITableViewCell class] forCellReuseIdentifier:@"alarmCell"];
    _alarmList.dataSource = self;
    _alarmList.delegate = self;
    [self.view addSubview:_alarmList];
}

- (void)dataInit {
    [SANYRequestUtils sanyGetAlarmDetailByStaffId:[SanyStaffUtil shareUtil].staffId result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        if (error == nil) {
            _alarmArray = result[@"rows"];
            [_alarmList reloadData];
        } else {
            [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _alarmArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alarmCell" forIndexPath:indexPath];
    NSDictionary *tmpDic = _alarmArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@   %@",tmpDic[@"evVehiNo"],tmpDic[@"paraNameShow"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SanyAlarmDetailViewController *alarmDetailViewController = [[SanyAlarmDetailViewController alloc]init];
    alarmDetailViewController.detailInfo = _alarmArray[indexPath.row];
    [self.navigationController pushViewController:alarmDetailViewController animated:YES];
}

@end
