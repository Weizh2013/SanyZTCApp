//
//  SanyChartTableViewCell.m
//  ZTCApp
//
//  Created by zousj on 16/6/30.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyChartTableViewCell.h"
#import "PNChart.h"

@implementation SanyChartTableViewCell
{
    PNBarChart * _barChart;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    static NSNumberFormatter *barChartFormatter;
    if (!barChartFormatter){
        barChartFormatter = [[NSNumberFormatter alloc] init];
        barChartFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        barChartFormatter.allowsFloats = NO;
        barChartFormatter.maximumFractionDigits = 0;
    }
    
    _barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170.0)];
    _barChart.strokeColor = PNGreen;
    _barChart.backgroundColor = [UIColor clearColor];
    _barChart.yLabelFormatter = ^(CGFloat yValue){
        return [barChartFormatter stringFromNumber:[NSNumber numberWithFloat:yValue]];
    };
    
    _barChart.yChartLabelWidth = 20.0;
    _barChart.chartMarginLeft = 30.0;
    _barChart.chartMarginRight = 10.0;
    _barChart.chartMarginTop = 5.0;
    _barChart.chartMarginBottom = 10.0;
    
    _barChart.labelMarginTop = 5.0;
    _barChart.showChartBorder = YES;
    _barChart.isGradientShow = NO;
    /// FIXME: 显示数据时，数字字体过大
    _barChart.isShowNumbers = NO;

    [_barChart strokeChart];
    [_chartBgView addSubview:_barChart];
    
    _chartColorView.backgroundColor = _barChart.strokeColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)bindChartWithXLabels:(NSArray *)xLabels yValues:(NSArray *)yValues {
//    [_barChart setYLabels:@[@5,@10,@15,@20]];

//    [_barChart strokeChart];
    
    // 当显示太密集时，减少精度显示
    while (xLabels.count > 10) {
        int tmpValue = xLabels.count%2;
        NSMutableArray *tmpXLbs = [NSMutableArray array];
        NSMutableArray *tmpYLbs = [NSMutableArray array];
        for (int i=0; i<xLabels.count; i++) {
            if (i%2!=tmpValue) {
                [tmpXLbs addObject:xLabels[i]];
                if (i==0) {
                    [tmpYLbs addObject:yValues[i]];
                }else {
                    [tmpYLbs addObject:@([yValues[i]integerValue]+[yValues[i-1]integerValue])];
                }
            }
        }
        xLabels = [NSArray arrayWithArray:tmpXLbs];
        yValues = [NSArray arrayWithArray:tmpYLbs];
    }
    
    [_barChart setXLabels:xLabels];
    [_barChart setYValues:yValues];
    [_barChart strokeChart];
}

@end
