//
//  SanyTripTableViewCell.m
//  ZTCApp
//
//  Created by zousj on 16/7/1.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyTripTableViewCell.h"

@implementation SanyTripTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindCellWithPlant:(NSString *)plant outlet:(NSString *)outlet time:(NSString *)time {
    _plantNameLb.text = plant;
    _outletNameLb.text = outlet;
    _timeLb.text = time;
}

@end
