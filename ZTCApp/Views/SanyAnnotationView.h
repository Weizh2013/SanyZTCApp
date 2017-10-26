//
//  SanyAnnotationView.h
//  ZTCApp
//
//  Created by zousj on 16/8/11.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "SanyCalloutView.h"

@interface SanyAnnotationView : MAPinAnnotationView     //MAAnnotationView

@property (nonatomic, readonly) UILabel         *annoLb;
@property (nonatomic, readonly) SanyCalloutView *calloutView;
@property (nonatomic, copy)     NSDictionary    *truckInfo;

@end
