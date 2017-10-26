//
//  CheckProVehiViewController.m
//  ZTCApp
//
//  Created by 魏宙辉 on 17/1/17.
//  Copyright © 2017年 Sany. All rights reserved.
//  待审查工程车辆列表
//

#import "CheckProVehiViewController.h"
#import "Masonry.h"

@interface CheckProVehiViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_vehiTableView;
}

@end

@implementation CheckProVehiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航栏显示初始化
    self.navigationItem.title = @"车辆列表";
    // 车辆列表显示初始化
    self.automaticallyAdjustsScrollViewInsets = NO;
    _vehiTableView = [[UITableView alloc]init];
    [self.view addSubview:_vehiTableView];
    [_vehiTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.bottom.left.right.mas_equalTo(0);
    }];
    [_vehiTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"vehiCell"];
    _vehiTableView.dataSource = self;
    _vehiTableView.delegate = self;
    _vehiTableView.allowsSelection = NO;
    _vehiTableView.separatorColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - delegate 
/**
 *  返回tableview段数的代理方法
 *
 *  @param tableView 当前tableview参数值
 *
 *  @return 返回tableview段数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.vehiArray.count;
}
/**
 *  返回tableview行数的代理方法
 *
 *  @param tableView 当前tableview参数值
 *  @param section   当前section参数值
 *
 *  @return 返回tableview行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"vehiCell" forIndexPath:indexPath];
    NSDictionary *vehiInfo = self.vehiArray[indexPath.section];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"车牌号:%@",vehiInfo[@"evVehiNo"]];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"运输企业:%@",vehiInfo[@"eiName"]];
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"司机:%@",vehiInfo[@"sfName"]];
        default:
            break;
    }
    return cell;
}

/**
 *  每台车辆信息分隔
 *
 *  @param tableView 当前tableview参数值
 *  @param section   当前section参数值
 *
 *  @return 分隔内容
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"🚚🚚🚚🚚🚚🚚🚚🚚🚚";
}





















@end
