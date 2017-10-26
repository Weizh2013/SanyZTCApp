//
//  SanyMonitorTableViewCell.h
//  ZTCApp
//
//  Created by zousj on 16/7/4.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SanyMonitorTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *carNumLb;
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carNumLength;

@end
