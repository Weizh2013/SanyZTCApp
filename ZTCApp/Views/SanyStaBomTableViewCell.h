//
//  SanyStaBomTableViewCell.h
//  ZTCApp
//
//  Created by zousj on 16/6/29.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 统计表单显示
 */
@interface SanyStaBomTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title1Lb;
@property (strong, nonatomic) IBOutlet UILabel *title2Lb;
@property (strong, nonatomic) IBOutlet UILabel *title3Lb;
@property (strong, nonatomic) IBOutlet UILabel *title4Lb;
@property (strong, nonatomic) IBOutlet UILabel *para1Lb;
@property (strong, nonatomic) IBOutlet UILabel *para2Lb;
@property (strong, nonatomic) IBOutlet UILabel *para3Lb;
@property (strong, nonatomic) IBOutlet UILabel *para4Lb;

/**
 * 管理者登陆进去后的界面
 */
- (void)reloadDataWithManagerDic:(NSDictionary *)managerDic;
/**
 * 老板登陆进去后的界面
 */
- (void)reloadDataWithAlarmDic:(NSDictionary *)alarmDic;
/**
 * 清空所有显示
 */
- (void)clearCell;

@end
