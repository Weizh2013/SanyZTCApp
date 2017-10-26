
//
//  SanyMonitorView.m
//  ZTCApp
//
//  Created by zousj on 16/7/4.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyMonitorView.h"
#import "SanyMonitorTableViewCell.h"
#import "Masonry.h"

@interface SanyMonitorView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_monitorTV;
}
@end
@implementation SanyMonitorView

- (instancetype)initWithData:(NSArray *)disAry {
    _disAry = disAry;
    if (self = [super init]) {
        _monitorTV = [[UITableView alloc]init];
        _monitorTV.backgroundColor = [UIColor clearColor];
        [self addSubview:_monitorTV];
        [_monitorTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(5);
            make.bottom.mas_equalTo(0);
        }];
        _monitorTV.dataSource = self;
        _monitorTV.delegate = self;
        _monitorTV.allowsSelection = NO;
        [_monitorTV registerNib:[UINib nibWithNibName:@"SanyMonitorTableViewCell" bundle:nil] forCellReuseIdentifier:@"monitorCell"];
    }
    self.backgroundColor = [UIColor colorWithValue:0xfefefe alpha:0.8];
    return self;
}

- (void)reloadData {
    [_monitorTV reloadData];
}

- (void)showView {
    [UIView animateWithDuration:DurationTime animations:^{
        self.frame = CGRectMake(0, SCREENHEIGHT-172-50, SCREENWIDTH, 172);
    }];
}

- (void)closeView {
    [UIView animateWithDuration:DurationTime animations:^{
        self.frame = CGRectMake(0, SCREENHEIGHT, self.frame.size.width, self.frame.size.height);
    }];
}

#pragma mark delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _disAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SanyMonitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"monitorCell" forIndexPath:indexPath];
    NSDictionary *dic = _disAry[indexPath.row];
    cell.timeLb.text = [[dic[@"startTime"]componentsSeparatedByString:@" "]lastObject];;
    cell.carNumLb.text = dic[@"evVehiNo"];
    cell.nameLb.text = dic[@"sfName"];
    cell.typeLb.text = dic[@"paraCnName"];
    cell.backgroundColor = [UIColor clearColor];
    cell.carNumLength.constant = 0.0f;          // 不显示车牌
    return cell;
}

@end
