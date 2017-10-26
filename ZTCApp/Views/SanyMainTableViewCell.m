//
//  SanyMainTableViewCell.m
//  ZTCApp
//
//  Created by zousj on 16/6/28.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyMainTableViewCell.h"
#import "Masonry.h"

@implementation SanyMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _numbersLb.textAlignment = NSTextAlignmentCenter;
    _numbersLb.layer.masksToBounds = YES;
    _numbersLb.layer.cornerRadius = 15.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCarInfoMode:(BOOL)carInfoMode {
    _carInfoMode = carInfoMode;
    if (_carInfoMode == YES) {
        _numbersLb.textAlignment = NSTextAlignmentRight;
        _numbersLb.layer.cornerRadius = 0.0f;
        _numbersLbWidth.constant = 150.0f;
    }
}

@end
