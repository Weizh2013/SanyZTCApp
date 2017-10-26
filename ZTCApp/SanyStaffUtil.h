//
//  SanyStaffUtil.h
//  ZTCApp
//
//  Created by zousj on 16/7/15.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SanyStaffType) {
    SanyStaffTypeGovernment = 0, //政府管理者
    SanyStaffTypeCompany = 1,    //企业管理者
    SanyStaffTypeDriver = 2      //司机
};

@interface SanyStaffUtil : NSObject

@property (nonatomic, assign) SanyStaffType type;
@property (nonatomic, copy) NSString *staffId;
@property (nonatomic, copy) NSString *userCode;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) BOOL isExer;      // 是否为执法者

    + (instancetype) shareUtil;

- (void)updateUtilWithLoginDic:(NSDictionary *)dic;

@end
