//
//  VehicleListViewController.h
//  ZTCApp
//
//  Created by 魏宙辉 on 17/1/18.
//  Copyright © 2017年 Sany. All rights reserved.
//

#import "SanyBaseVC.h"
#import "SanyManagerMonitorVC.h"

@interface VehicleListViewController : SanyBaseVC

@property (nonatomic,copy) NSArray *vehicleArray;
@property (nonatomic,weak) SanyManagerMonitorVC *monitorController;

@end
