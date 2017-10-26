//
//  SanyDrawListVC.h
//  ZTCApp
//
//  Created by zousj on 16/12/29.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyBaseVC.h"

/**
 * 画图前的工地（或消纳场、限速圈）列表
 */

@interface SanyDrawListVC : SanyBaseVC

/**
 *  drawCategory = 0 绘工地
 *  drawCategory = 1 绘消纳场
 *  drawCategory = 2 绘限速圈
 */
@property (nonatomic,assign) NSInteger drawCategory;

@end
