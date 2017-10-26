//
//  SanyCheckViewController.m
//  ZTCApp
//
//  Created by 魏宙辉 on 17/1/17.
//  Copyright © 2017年 Sany. All rights reserved.
//

#import "SanyCheckViewController.h"
#import "Masonry.h"
#import "SanyProjDetailViewController.h"

@interface SanyCheckViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    // 待审核工地列表（后台数据)
    NSArray *_projList;

    // 待审核工地列表视图
    UITableView *_projTableView;
}

- (void)viewInit;
- (void)dataInit;

@end

@implementation SanyCheckViewController

#pragma mark - private
/**
 *  视图加载完成
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
}

/**
 *  视图将要显示
 *
 *  @param animated 是否有动画
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self dataInit];
}

/**
 *  视图初始化显示
 */
- (void)viewInit {
    // 初始化导航栏显示
    self.navigationItem.title = @"待审核列表";
    // 初始化列表显示
    self.automaticallyAdjustsScrollViewInsets = NO;
    _projTableView = [[UITableView alloc] init];
    [self.view addSubview:_projTableView];
    [_projTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(-44);
        make.left.right.mas_equalTo(0);
    }];
    [_projTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"projCell"];
    _projTableView.dataSource = self;
    _projTableView.delegate = self;
}

/**
 *  数据初始化
 */
- (void)dataInit {
    [SANYRequestUtils sanyCheckProjectResult:^(NSDictionary *_Nullable result, NSError *_Nullable error) {
        if (error == nil) {
            _projList = result[@"rows"];
            [_projTableView reloadData];
        } else {
            [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
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
    return _projList.count;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"projCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ --> %@", _projList[indexPath.row][@"piName"], _projList[indexPath.row][@"efName"]];
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
    SanyProjDetailViewController *projDetailViewController = [[SanyProjDetailViewController alloc] init];
    projDetailViewController.projInfo = _projList[indexPath.row];
    [self.navigationController pushViewController:projDetailViewController animated:YES];
}

@end
