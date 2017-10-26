//
//  VehicleListViewController.m
//  ZTCApp
//
//  Created by 魏宙辉 on 17/1/18.
//  Copyright © 2017年 Sany. All rights reserved.
//

#import "VehicleListViewController.h"
#import "Masonry.h"

@interface VehicleListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_vehicleTableView;

    NSMutableDictionary *_formatDic;
}
@end

@implementation VehicleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInit];
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

- (void)dataInit {
    _formatDic = [NSMutableDictionary dictionary];
    for (NSDictionary *tmpDic in self.vehicleArray) {
        if (_formatDic[tmpDic[@"eiName"]] == nil) {
            // 新增字段
            NSMutableArray *tmpAry = [NSMutableArray arrayWithObject:tmpDic];
            [_formatDic setObject:tmpAry forKey:tmpDic[@"eiName"]];
        } else {
            NSMutableArray *tmpAry = _formatDic[tmpDic[@"eiName"]];
            [tmpAry addObject:tmpDic];
        }
    }
}

- (void)viewInit {
    self.navigationItem.title = @"车辆列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 列表显示初始化
    _vehicleTableView = [[UITableView alloc] init];
    [self.view addSubview:_vehicleTableView];
    [_vehicleTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.bottom.mas_equalTo(0);
    }];
    [_vehicleTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"vehicleCell"];
    _vehicleTableView.dataSource = self;
    _vehicleTableView.delegate = self;
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _formatDic.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_formatDic[_formatDic.allKeys[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"vehicleCell"];
    NSArray *tmpAry = _formatDic[_formatDic.allKeys[indexPath.section]];
    cell.textLabel.text = tmpAry[indexPath.row][@"evVehiNo"];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _formatDic.allKeys[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.monitorController.displayVehicle = _formatDic[_formatDic.allKeys[indexPath.section]][indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
