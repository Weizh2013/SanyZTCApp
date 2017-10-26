//
//  SanyCertListVC.m
//  ZTCApp
//
//  Created by zousj on 16/9/23.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyCertListVC.h"
#import "SanyMainTableViewCell.h"

@interface SanyCertListVC () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_listVC;
    NSArray     *_certList;
}
@end

@implementation SanyCertListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"核准证列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _listVC = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    [_listVC registerNib:[UINib nibWithNibName:@"SanyMainTableViewCell" bundle:nil] forCellReuseIdentifier:@"mainCell"];
    _listVC.allowsSelection = NO;
    _listVC.dataSource = self;
    _listVC.delegate = self;
    [self.view addSubview:_listVC];
    
    [SANYRequestUtils sanyWorkSiteCertWith:_piId result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        if (error == nil) {
            _certList = result[@"rows"];
            [_listVC reloadData];
        }else {
            [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _certList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SanyMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    cell.carInfoMode = YES;
    cell.mainTitleLb.text = _certList[indexPath.row][@"acNum"];
    cell.numbersLb.text = _certList[indexPath.row][@"evVehiNo"];
    return cell;
}

@end
