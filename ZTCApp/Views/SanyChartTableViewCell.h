//
//  SanyChartTableViewCell.h
//  ZTCApp
//
//  Created by zousj on 16/6/30.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 显示柱状图 固定200高度
 */
@interface SanyChartTableViewCell : UITableViewCell
/**
 * 柱状图的背景view
 */
@property (weak, nonatomic) IBOutlet UIView *chartBgView;
/**
 * 柱状图的颜色说明
 */
@property (weak, nonatomic) IBOutlet UIView *chartColorView;
/**
 * 柱状图的变量说明
 */
@property (weak, nonatomic) IBOutlet UILabel *chartColorLb;


- (void)bindChartWithXLabels:(NSArray *)xLabels yValues:(NSArray *)yValues;


@end
