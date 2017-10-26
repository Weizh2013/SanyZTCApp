//
//  SanyImgSelectorTableViewCell.m
//  ZTCApp
//
//  Created by 魏宙辉 on 17/1/23.
//  Copyright © 2017年 Sany. All rights reserved.
//

#import "SanyImgSelectorTableViewCell.h"

@implementation SanyImgSelectorTableViewCell
{
    id _target;
    SEL _selector;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_imgSelectorButton setImage:[[UIImage imageNamed:@"addImage"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}

- (void)addTarget:(id)target selector:(SEL)selector {
    if ([_target isEqual:target]) {
        return;
    }
    _target = target;
    _selector = selector;
}

- (IBAction)imgSelectorButtonClicked:(id)sender {
    [_target performSelector:_selector withObject:_imgSelectorButton];
}

- (void)setImageForSelectorButton:(UIImage *)image {
    [_imgSelectorButton setImage:image forState:UIControlStateNormal];
}

@end
