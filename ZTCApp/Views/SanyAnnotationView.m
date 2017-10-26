//
//  SanyAnnotationView.m
//  ZTCApp
//
//  Created by zousj on 16/8/11.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyAnnotationView.h"

@interface SanyAnnotationView ()

@property (nonatomic, strong, readwrite) SanyCalloutView *calloutView;

@end

@implementation SanyAnnotationView

#define kCalloutWidth       300.0
#define kCalloutHeight      6*30.0

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            self.calloutView = [[SanyCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        
        self.calloutView.callOutInfo = _truckInfo;
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (void)setTruckInfo:(NSDictionary *)truckInfo {
    _truckInfo = truckInfo;
    self.calloutView.callOutInfo = _truckInfo;
}

@end
