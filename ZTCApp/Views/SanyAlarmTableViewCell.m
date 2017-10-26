//
//  SanyAlarmTableViewCell.m
//  ZTCApp
//
//  Created by zousj on 16/7/20.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyAlarmTableViewCell.h"
#import "Masonry.h"

@implementation SanyAlarmTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)clearCell {
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            view.hidden = YES;
        }
    }
}

- (void)reloadDataWithDic:(NSDictionary *)dic {
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mutDic removeObjectForKey:@"eiName"];
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.font = [UIFont boldSystemFontOfSize:17.0f];
    titleLb.text = dic[@"eiName"];
    [self.contentView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(5.0);
        make.right.mas_equalTo(-100.0f);
        make.height.mas_equalTo(25.0f);
    }];
    for (int i=0;i<mutDic.allKeys.count;i++) {
        NSString *key = mutDic.allKeys[i];
        UILabel *nameLb     = [[UILabel alloc]init];
        UILabel *valueLb    = [[UILabel alloc]init];
        nameLb.font         = [UIFont boldSystemFontOfSize:17.0f];
        valueLb.font        = [UIFont systemFontOfSize:17.0f];
        nameLb.text         = key;
        valueLb.text        = [dic[key]description];
        valueLb.textColor   = [UIColor grayColor];
        valueLb.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:nameLb];
        [self.contentView addSubview:valueLb];
        [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(titleLb);
            make.top.mas_equalTo(5.0+30.0f*(i+1));
        }];
        [valueLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(nameLb);
            make.left.equalTo(nameLb.mas_right).offset(5);
            make.right.mas_equalTo(-15.0f);
        }];
    }
}

@end
