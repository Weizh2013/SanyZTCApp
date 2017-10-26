//
//  SanyTripTableViewCell.h
//  ZTCApp
//
//  Created by zousj on 16/7/1.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 趟次列表
 */
@interface SanyTripTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *plantNameLb;
@property (weak, nonatomic) IBOutlet UILabel *outletNameLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *plantTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *outletTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLb;

- (void)bindCellWithPlant:(NSString *)plant outlet:(NSString *)outlet time:(NSString *)time;
@end
