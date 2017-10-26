//
//  SanyNavigationVC.h
//  ZTCApp
//
//  Created by zousj on 16/7/5.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyBaseVC.h"

/**
* 位置地图 导航界面
*/
@interface SanyNavigationVC : SanyBaseVC

@property (nonatomic,copy)      NSString        *mapTitle;
@property (nonatomic,strong)    NSDictionary    *mapInfo;
@property (nonatomic,assign)    SanyInfoType    type;

@end
