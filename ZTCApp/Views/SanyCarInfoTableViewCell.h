//
//  SanyCarInfoTableViewCell.h
//  ZTCApp
//
//  Created by zousj on 16/11/1.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SanyCarInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mainTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLb;

- (void)bindCellWithMainTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle;

@end
