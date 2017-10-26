//
//  SanyPollingView.m
//  ZTCApp
//
//  Created by zousj on 16/7/28.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyPollingView.h"
#define DurationTime 0.5

@implementation SanyPollingView
{
    UIButton    *_nextBt;
    UIButton    *_previousBt;
    UILabel     *_titleLb;
    
    CGRect      _showFrame;
    CGRect      _hideFrame;
    
    NSInteger   _length;
}

#pragma mark - interface -
- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame length:(NSInteger)length{
    if (self = [super init]) {
        _previousBt = [UIButton buttonWithType:UIButtonTypeSystem];
        _previousBt.frame = CGRectMake(0, 0, 45.0f, 45.0f);
        [_previousBt addTarget:self action:@selector(previousBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_previousBt setImage:[[UIImage imageNamed:@"icon_previous_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_previousBt setImage:[[UIImage imageNamed:@"icon_previous"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateDisabled];
        [self addSubview:_previousBt];
        _nextBt = [UIButton buttonWithType:UIButtonTypeSystem];
        _nextBt.frame = CGRectMake(55.0, 0, 45.0f, 45.0f);
        [_nextBt addTarget:self action:@selector(nextBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_nextBt setImage:[[UIImage imageNamed:@"icon_next_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_nextBt setImage:[[UIImage imageNamed:@"icon_next"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateDisabled];
        [self addSubview:_nextBt];
        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, 100, 25)];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.text = title;
        [self addSubview:_titleLb];
        _showFrame = CGRectMake(frame.origin.x, frame.origin.y, 100, 70);
        _hideFrame = CGRectMake(frame.origin.x, frame.origin.y, 100, 0);
        self.frame = _hideFrame;
        _length = length;
        [self showPollingViewAnimate:YES];
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)hidePollingViewAnimate:(BOOL)animate {
    [UIView animateWithDuration:DurationTime animations:^{
        self.frame = _hideFrame;
    }];
}

- (void)showPollingViewAnimate:(BOOL)animate {
    [UIView animateWithDuration:DurationTime animations:^{
        self.frame = _showFrame;
    }];
    _currentPosition = 0;
    _previousBt.enabled = NO;
    _nextBt.enabled = YES;
}

#pragma mark - private -
- (void)previousBtClicked:(UIButton *)sender {
    if (_currentPosition>1) {
        _currentPosition--;
        [self rangeCheck];
    }
}

- (void)nextBtClicked:(UIButton *)sender {
    if (_currentPosition<_length) {
        _currentPosition++;
        [self rangeCheck];
    }
}

- (void)rangeCheck {
    _previousBt.enabled = YES;
    _nextBt.enabled = YES;
    if (_currentPosition <= 1) {
        _previousBt.enabled = NO;
    }else if (_currentPosition >= _length){
        _nextBt.enabled = NO;
    }
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
