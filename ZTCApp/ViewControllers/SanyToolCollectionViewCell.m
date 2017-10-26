//
//  SanyToolCollectionViewCell.m
//  ZTCApp
//
//  Created by zousj on 16/12/28.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyToolCollectionViewCell.h"

@implementation SanyToolCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)bindCellWithImage:(NSString *)imageName name:(NSString *)name {
    self.btImage.image = [UIImage imageNamed:imageName];
    self.btName.text = name;
}

@end
