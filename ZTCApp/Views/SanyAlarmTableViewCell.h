//
//  SanyAlarmTableViewCell.h
//  ZTCApp
//
//  Created by zousj on 16/7/20.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 报警页面
 */
@interface SanyAlarmTableViewCell : UITableViewCell

- (void)clearCell;
- (void)reloadDataWithDic:(NSDictionary *)dic;

@end
