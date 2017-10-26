//
//  SanyStaffUtil.m
//  ZTCApp
//
//  Created by zousj on 16/7/15.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyStaffUtil.h"

static SanyStaffUtil *sharedUtil;

@implementation SanyStaffUtil

+ (instancetype)shareUtil {
    if (sharedUtil == nil) {
        sharedUtil = [[SanyStaffUtil alloc]init];
    }
    return sharedUtil;
}

- (void)updateUtilWithLoginDic:(NSDictionary *)dic {
    _userCode   = dic[@"userCode"];
    _staffId    = dic[@"staffId"];
    _startTime  = dic[@"transportStartTime"];
    _endTime    = dic[@"transportEndTime"];
    _coordinate.latitude = [dic[@"initLat"]floatValue];
    _coordinate.longitude = [dic[@"initLng"]floatValue];

    NSString *staffType = dic[@"staffType"];
    NSString *driver    = dic[@"driver"];
    if (staffType.integerValue==0) {
        _isExer = NO;
        _type = SanyStaffTypeGovernment;
        if (driver.integerValue == 2) {
            _isExer = YES;
        }
    }else if (staffType.integerValue==1 && driver.integerValue==0) {
        _type = SanyStaffTypeCompany;
    }else if (staffType.integerValue==1 && driver.integerValue==1){
        _type = SanyStaffTypeDriver;
    }else{
        /// TODO: 保留
    }
}

@end
