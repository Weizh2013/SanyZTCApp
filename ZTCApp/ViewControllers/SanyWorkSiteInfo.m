//
//  SanyWorkSiteInfo.m
//  ZTCApp
//
//  Created by zousj on 16/9/23.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyWorkSiteInfo.h"
#import "SanyDriverMainTC.h"
#import "SanyWorkSiteVC.h"
#import "SanyRouteVC.h"
#import "SanyCertListVC.h"
#import "Masonry.h"

@interface SanyWorkSiteInfo ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_mainTV;
}
@end

@implementation SanyWorkSiteInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark initilize
- (void)viewInit {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"工地详情";
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
}

#pragma mark delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6 + 2*[_worksiteInfo[@"routeInf"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SanyDriverMainTC *cell = [tableView dequeueReusableCellWithIdentifier:@"driverCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *outletAry = _worksiteInfo[@"routeInf"];
    switch (indexPath.row) {
        case 0: //工地
            [cell bindWithImage:@"工地" titleStr:@"工地" detailStr:_worksiteInfo[@"workSiteName"]];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            break;
        case 1: //开工时间
            [cell bindWithImage:@"开始" titleStr:@"开工时间" detailStr:_worksiteInfo[@"starTime"]];
            break;
        case 2: //结束时间
            [cell bindWithImage:@"结束" titleStr:@"结束时间" detailStr:_worksiteInfo[@"endTime"]];
            break;
        case 3: //准运开始时间
            [cell bindWithImage:@"开始" titleStr:@"准运开始时间" detailStr:_worksiteInfo[@"shipStartTime"]];
            break;
        case 4: //准运结束时间
            [cell bindWithImage:@"结束" titleStr:@"准运结束时间" detailStr:_worksiteInfo[@"shipEndTime"]];
            break;
        case 5: //核准证
            [cell bindWithImage:@"工地" titleStr:@"车辆核准证号" detailStr:@"点击查看详情"];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            break;
        default: {
            if (indexPath.row % 2) {
                [cell bindWithImage:@"消纳厂" titleStr:[NSString stringWithFormat:@"消纳厂%ld",(indexPath.row-4)/2] detailStr:outletAry[(indexPath.row-4)/2-1][@"pceiIdName"]];
            }else {
                [cell bindWithImage:@"路线" titleStr:[NSString stringWithFormat:@"路线%ld",(indexPath.row-4)/2] detailStr:outletAry[(indexPath.row-4)/2-1][@"routeDest"]];
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            }
            break;
        }
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
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
        workSiteVC.efId = _worksiteInfo[@"workSiteId"];;
        workSiteVC.worksiteName = _worksiteInfo[@"workSiteName"];
        [self.navigationController pushViewController:workSiteVC animated:YES];
    }else if (indexPath.row == 5) {
        SanyCertListVC *certListVC = [SanyCertListVC new];
        certListVC.piId = _worksiteInfo[@"pi_id"];
        [self.navigationController pushViewController:certListVC animated:YES];
    }
    else if (indexPath.row < 5) {
        return;
    }else if (indexPath.row % 2) {
        return;
    }else {
        NSString *routeId = _worksiteInfo[@"routeInf"][(indexPath.row-3)/2-1][@"routeId"];
        SanyRouteVC *sanyRVC = [[SanyRouteVC alloc]init];
        sanyRVC.routeId = routeId;
        [self.navigationController pushViewController:sanyRVC animated:YES];
    }
}


@end
