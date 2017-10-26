//
//  SanyMainTableViewCell.h
//  ZTCApp
//
//  Created by zousj on 16/6/28.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SanyMainTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *mainTitleLb;
@property (strong, nonatomic) IBOutlet UILabel *numbersLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numbersLbWidth;

@property (nonatomic,assign) BOOL carInfoMode;      //default is NO;

@end
