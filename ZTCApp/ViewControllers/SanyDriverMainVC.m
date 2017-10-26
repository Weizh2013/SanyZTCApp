//
//  SanyDriverMainVC.m
//  ZTCApp
//
//  Created by zousj on 16/7/1.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyDriverMainVC.h"
#import "SanyDriverMainTC.h"
#import "SanyWorkSiteVC.h"
#import "SanyRouteVC.h"
#import "Masonry.h"

@interface SanyDriverMainVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_mainTV;
    
    NSArray *_plantAry;     // 后台请求过来的原始数据
}
@end

@implementation SanyDriverMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self dataInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark initilize
- (void)dataInit {
    [SANYRequestUtils sanyRequestCertMainResult:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        if (error == nil) {
            _plantAry = result[@"rows"];
            [_mainTV reloadData];
        }else {
            [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

- (void)viewInit {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"首页";
    _mainTV = [[UITableView alloc]init];
    [self.view addSubview:_mainTV];
    [_mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
    _mainTV.backgroundColor = self.view.backgroundColor;
    [_mainTV registerClass:[SanyDriverMainTC class] forCellReuseIdentifier:@"driverCell"];
    UIView *view = [UIView new];
    view.backgroundColor = self.view.backgroundColor;
    _mainTV.tableFooterView = view;
    _mainTV.dataSource = self;
    _mainTV.delegate = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        /// TODO: 重新刷新请求网络，并重新加载页面
        [_mainTV.mj_header performSelector:@selector(endRefreshing) withObject:nil afterDelay:3.0f];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"松手刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松手刷新数据" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"刷新完成" forState:MJRefreshStateWillRefresh];
    [header setTitle:@"刷新完成" forState:MJRefreshStateNoMoreData];
    _mainTV.mj_header = header;
}

#pragma mark delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _plantAry.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5 + 2*[_plantAry[section][@"routeInf"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SanyDriverMainTC *cell = [tableView dequeueReusableCellWithIdentifier:@"driverCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = _plantAry[indexPath.section];
    NSArray *outletAry = dic[@"routeInf"];
    switch (indexPath.row) {
        case 0: //工地
            [cell bindWithImage:@"工地" titleStr:@"工地" detailStr:dic[@"workSiteName"]];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            break;
        case 1: //开工时间
            [cell bindWithImage:@"开始" titleStr:@"开工时间" detailStr:dic[@"starTime"]];
            break;
        case 2: //结束时间
            [cell bindWithImage:@"结束" titleStr:@"结束时间" detailStr:dic[@"endTime"]];
            break;
        case 3: //准运开始时间
            [cell bindWithImage:@"开始" titleStr:@"准运开始时间" detailStr:dic[@"shipStartTime"]];
            break;
        case 4: //准运结束时间
            [cell bindWithImage:@"结束" titleStr:@"准运结束时间" detailStr:dic[@"shipEndTime"]];
            break;
        default: {
            if (indexPath.row % 2) {
                [cell bindWithImage:@"消纳厂" titleStr:[NSString stringWithFormat:@"消纳厂%ld",(indexPath.row-3)/2] detailStr:outletAry[(indexPath.row-3)/2-1][@"pceiIdName"]];
            }else {
                [cell bindWithImage:@"路线" titleStr:[NSString stringWithFormat:@"路线%ld",(indexPath.row-3)/2] detailStr:outletAry[(indexPath.row-3)/2-1][@"routeDest"]];
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            }
            break;
        }
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = _plantAry[section];
    return [NSString stringWithFormat:@"  核准证号：%@",dic[@"acNum"]];
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setTextColor:[UIColor grayColor]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        SanyWorkSiteVC *workSiteVC = [[SanyWorkSiteVC alloc]init];
        workSiteVC.efId = _plantAry[indexPath.section][@"workSiteId"];;
        workSiteVC.worksiteName = _plantAry[indexPath.section][@"workSiteName"];
        [self.navigationController pushViewController:workSiteVC animated:YES];
    }else if (indexPath.row <= 4) {
        return;
    }else if (indexPath.row % 2) {
        return;
    }else {
        NSString *routeId = _plantAry[indexPath.section][@"routeInf"][(indexPath.row-3)/2-1][@"routeId"];
        SanyRouteVC *sanyRVC = [[SanyRouteVC alloc]init];
        sanyRVC.routeId = routeId;
        [self.navigationController pushViewController:sanyRVC animated:YES];
    }
}

@end
