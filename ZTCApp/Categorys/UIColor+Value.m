//
//  UIColor+Value.m
//  ZTCApp
//
//  Created by zousj on 16/6/28.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "UIColor+Value.h"

@implementation UIColor (Value)

+ (UIColor *)colorWithValue:(NSInteger)colorValue alpha:(CGFloat)alpha{
    NSInteger redValue = colorValue/256/256;
    NSInteger blueValue = colorValue%256;
    NSInteger greenValue = (colorValue - redValue*256*256)/256;
    return [UIColor colorWithRed:(CGFloat)redValue/256.0 green:(CGFloat)greenValue/256.0 blue:(CGFloat)blueValue/256.0 alpha:alpha];
}

@end
