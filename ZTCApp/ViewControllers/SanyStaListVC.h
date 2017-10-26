//
//  SanyStaListVC.h
//  ZTCApp
//
//  Created by zousj on 16/6/30.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyBaseVC.h"

/**
 * 统计列表
 */
@interface SanyStaListVC : SanyBaseVC

@property (nonatomic,copy) NSString *staTitle;
@property (nonatomic,copy) NSString *mainTitle;
@property (nonatomic,copy) NSString *subTitle;

@property (nonatomic,strong) NSMutableDictionary *staData;

@end
