//
//  SanyBossMonitorVC.h
//  ZTCApp
//
//  Created by zousj on 16/6/30.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyBaseVC.h"

/**
 * 企业管理者（老板） 监控
 */
@interface SanyBossMonitorVC : SanyBaseVC <UITabBarControllerDelegate>

@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *endTime;
@property (nonatomic,copy) NSString *speed;

@end
