//
//  SanyCalloutView.m
//  ZTCApp
//
//  Created by zousj on 16/8/11.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyCalloutView.h"
#import "SanyMainTableViewCell.h"

@interface SanyCalloutView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSInteger   _rows;
}
@end

@implementation SanyCalloutView

#define kArrorHeight        10

- (void)drawRect:(CGRect)rect
{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    _tableView = [[UITableView alloc]initWithFrame:self.bounds];
    [_tableView registerNib:[UINib nibWithNibName:@"SanyMainTableViewCell" bundle:nil] forCellReuseIdentifier:@"mainCell"];
//    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"callOutCell"];
    _tableView.dataSource   = self;
    _tableView.delegate     = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self addSubview:_tableView];
    _rows = 0;
}

- (void)setCallOutInfo:(NSDictionary *)callOutInfo {
    _rows = 6;
    _callOutInfo = callOutInfo;
    [_tableView reloadData];
}

#pragma mark - <table view delegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rows;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SanyMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    cell.carInfoMode = YES;
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"callOutCell"];
    switch (indexPath.row) {
        case 0:
            cell.mainTitleLb.text = @"SIM卡手机号";
            cell.numbersLb.text = _callOutInfo[@"phoneNum"];
            break;
        case 1:
            cell.mainTitleLb.text = @"重载状态";
            cell.numbersLb.text = [_callOutInfo[@"beanStatusInfo"][@"loadState"]integerValue]?@"有载重":@"无载重";
            break;
        case 2:
            cell.mainTitleLb.text = @"篷布状态";
            cell.numbersLb.text = [_callOutInfo[@"beanStatusInfo"][@"tarpaulinState"]integerValue]?@"开启":@"关闭";
            break;
        case 3:
            cell.mainTitleLb.text = @"举升状态";
            cell.numbersLb.text = [_callOutInfo[@"beanStatusInfo"][@"riseState"]integerValue]?@"开启":@"关闭";
            break;
        case 4:
            cell.mainTitleLb.text = @"地址";
            cell.numbersLb.text = _callOutInfo[@"mapPosition"];
            break;
        case 5:
            cell.mainTitleLb.text = @"GPS定位时间";
            cell.numbersLb.text = _callOutInfo[@"serverTime"];
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
}

@end
