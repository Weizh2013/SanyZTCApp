//
//  SanyMonitorView.h
//  ZTCApp
//
//  Created by zousj on 16/7/4.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DurationTime 0.5

@interface SanyMonitorView : UIView

@property (nonatomic,copy) NSArray *disAry;

- (instancetype)initWithData:(NSArray *)disAry;

- (void)reloadData;

- (void)showView;

- (void)closeView;

@end
