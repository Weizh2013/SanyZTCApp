//
//  SanyDrawListVC.m
//  ZTCApp
//
//  Created by zousj on 16/12/29.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyDrawListVC.h"
#import "SanyDrawVC.h"
#import "Masonry.h"

@interface SanyDrawListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_drawListTV;
    NSInteger   _drawType;
    NSArray     *_listAry;
}
@end

@implementation SanyDrawListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
    [self dataInit];
}


- (void)viewInit {
    self.navigationItem.title = @"采集列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.tabBar.hidden = YES;
    _drawListTV = [[UITableView alloc]init];
    [_drawListTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"drawCell"];
    [self.view addSubview:_drawListTV];
    [_drawListTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.bottom.mas_equalTo(0);
    }];
    _drawListTV.dataSource = self;
    _drawListTV.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)dataInit {
    switch (self.drawCategory) {
        case 0:
            /* 绘工地 */
            _drawType = 2;
            break;
        case 1:
            /* 绘消纳场 */
            _drawType = 3;
            break;
        case 2:
            /* 绘限速圈 */
            _drawType = 5;
            break;
        default:
            _drawType = 0;
            break;
    }
    
    [SANYRequestUtils sanyRequestDrawListWithType:_drawType result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        if (error == nil) {
            _listAry = result[@"rows"];
            [_drawListTV reloadData];
        }else {
            [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"drawCell"];
    cell.textLabel.text = _listAry[indexPath.row][@"efName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SanyDrawVC *sanyDrawVC = [[SanyDrawVC alloc]init];
    sanyDrawVC.efNo = _listAry[indexPath.row][@"efNo"];
    [self.navigationController pushViewController:sanyDrawVC animated:YES];
}

@end
