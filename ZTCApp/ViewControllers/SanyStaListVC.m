//
//  SanyStaListVC.m
//  ZTCApp
//
//  Created by zousj on 16/6/30.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyStaListVC.h"
#import "SanyMainTableViewCell.h"
#import "Masonry.h"

@interface SanyStaListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_staTabView;
    NSArray     *_keyAry;
}
@end

@implementation SanyStaListVC

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark initilize
- (void)dataInit {
    /// FIXME: 暂定本页面不请求数据，由上个页面传过来
    _keyAry = _staData.allKeys;
}

- (void)viewInit {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = _staTitle;
    _staTabView = [[UITableView alloc]init];
    [self.view addSubview:_staTabView];
    [_staTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.bottom.left.right.mas_equalTo(0);
    }];
    [_staTabView registerNib:[UINib nibWithNibName:@"SanyMainTableViewCell" bundle:nil] forCellReuseIdentifier:@"mainCell"];
    _staTabView.dataSource = self;
    _staTabView.delegate = self;
    _staTabView.backgroundColor = self.view.backgroundColor;
    UIView *view = [UIView new];
    view.backgroundColor = self.view.backgroundColor;
    _staTabView.tableFooterView = view;
    _staTabView.allowsSelection = NO;
}

#pragma mark delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _keyAry.count + 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SanyMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.backgroundColor = self.view.backgroundColor;
        cell.mainTitleLb.text = nil;
        cell.numbersLb.text = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (indexPath.row == 1) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.mainTitleLb.text = _mainTitle;
        cell.numbersLb.text = _subTitle;
    }else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.mainTitleLb.text = [_keyAry[indexPath.row-2] description];
        cell.numbersLb.text = [_staData[_keyAry[indexPath.row-2]] description];
    }
    return cell;
}
@end
