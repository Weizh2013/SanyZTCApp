//
//  SanyManagerMonitorVC.h
//  ZTCApp
//
//  Created by zousj on 16/6/28.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyBaseVC.h"

/**
 * 管理者 监控
 */
@interface SanyManagerMonitorVC : SanyBaseVC <UITabBarControllerDelegate>

/**
 *  要显示的车辆信息，为nil表示不用显示
 */
@property (nonatomic,copy) NSDictionary *displayVehicle;

@end
