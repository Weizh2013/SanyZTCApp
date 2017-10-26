//
//  SanyDriverMainTC.m
//  ZTCApp
//
//  Created by zousj on 16/9/6.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyDriverMainTC.h"
#import "Masonry.h"

#define SPACE 5.0f

@implementation SanyDriverMainTC
{
    UIImageView *_iconImageView;
    UILabel     *_titleLb;
    UILabel     *_detailLb;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.layer.cornerRadius = 3.0f;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.0f);
            make.top.mas_equalTo(SPACE);
            make.width.height.mas_equalTo(30.0f);
        }];
        
        _titleLb = [[UILabel alloc]init];
//        _titleLb.backgroundColor = [UIColor yellowColor];
        _titleLb.font = [UIFont boldSystemFontOfSize:18.0f];
        _titleLb.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_iconImageView);
            make.left.equalTo(_iconImageView.mas_right).offset(SPACE);
            make.right.mas_equalTo(-SPACE);
        }];
        
        _detailLb = [[UILabel alloc]init];
//        _detailLb.backgroundColor = [UIColor greenColor];
        _detailLb.font = [UIFont systemFontOfSize:15.0f];
        _detailLb.numberOfLines = 0;
        _detailLb.textColor = [UIColor grayColor];
        [self.contentView addSubview:_detailLb];
        [_detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImageView);
            make.right.equalTo(_titleLb);
            make.top.equalTo(_titleLb.mas_bottom).offset(SPACE);
            make.bottom.mas_equalTo(-SPACE);
        }];
    }
    return self;
}

- (void)bindWithImage:(NSString *)image titleStr:(NSString *)titleStr detailStr:(NSString *)detailStr {
    _iconImageView.image = [UIImage imageNamed:image];
    _titleLb.text = titleStr;
    _detailLb.text = detailStr;
}



@end


















