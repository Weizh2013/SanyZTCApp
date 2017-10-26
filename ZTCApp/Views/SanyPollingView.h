//
//  SanyPollingView.h
//  ZTCApp
//
//  Created by zousj on 16/7/28.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SanyPollingView : UIControl

@property (nonatomic,assign,readonly) NSInteger currentPosition;

- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame length:(NSInteger)length;

- (void)hidePollingViewAnimate:(BOOL)animate;

- (void)showPollingViewAnimate:(BOOL)animate;

@end
