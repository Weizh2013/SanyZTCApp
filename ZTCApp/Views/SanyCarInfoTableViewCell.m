//
//  SanyCarInfoTableViewCell.m
//  ZTCApp
//
//  Created by zousj on 16/11/1.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyCarInfoTableViewCell.h"

@implementation SanyCarInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)bindCellWithMainTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle {
    _mainTitleLb.text = mainTitle;
    _subTitleLb.text = subTitle;
}
@end
