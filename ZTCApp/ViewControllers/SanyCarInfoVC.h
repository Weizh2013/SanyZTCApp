//
//  SanyCarInfoVC.h
//  ZTCApp
//
//  Created by zousj on 16/11/1.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyBaseVC.h"
#import "SanyBossMonitorVC.h"

@interface SanyCarInfoVC : SanyBaseVC

@property (nonatomic,copy) NSString             *carNo;
@property (nonatomic,copy) NSDictionary         *carInfo;
@property (nonatomic,weak) SanyBossMonitorVC    *bossMonitorVC;

@end
