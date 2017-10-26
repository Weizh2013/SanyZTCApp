//
//  SANYRequestUtils.h
//  ZTCApp
//
//  Created by zousj on 16/7/15.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SanyInfoType) {
    SanyInfoTypeCar = 1,         //运行车辆
    SanyInfoTypeSite = 2,        //运行工地
    SanyInfoTypeConsumField = 3, //运行消纳厂
    SanyInfoTypeDriver = 4       //司机
};

typedef void (^ResultType)(NSDictionary *_Nullable result, NSError *_Nullable error);

@interface SANYRequestUtils : NSObject

+ (void)sanyRequestLoginWithUserCode:(NSString *_Nullable)userCode password:(NSString *_Nullable)password result:(ResultType _Nullable)result;
+ (void)sanyRequestMainWithStartTime:(NSString *_Nullable)startTime endTime:(NSString *_Nullable)endTime result:(ResultType _Nullable)result;
+ (void)sanyRequestListInfoWithStartTime:(NSString *_Nullable)startTime endTime:(NSString *_Nullable)endTime type:(SanyInfoType)type result:(ResultType _Nullable)result;
+ (void)sanyRequestCountWithStartTime:(NSString *_Nullable)startTime endTime:(NSString *_Nullable)endTime result:(ResultType _Nullable)result;
+ (void)sanyRequestMapInfoWithMapInfo:(NSDictionary *_Nullable)mapInfo type:(SanyInfoType)type result:(ResultType _Nullable)result;
+ (void)sanyRequestMonitorWithStartTime:(NSString *_Nullable)startTime endTime:(NSString *_Nullable)endTime carNo:(NSString *_Nullable)carNo result:(ResultType _Nullable)result;
+ (void)sanyRequestBossMainWithStartTime:(NSString *_Nullable)startTime endTime:(NSString *_Nullable)endTime result:(ResultType _Nullable)result;
+ (void)sanyRequestAlarmStartTime:(NSString *_Nullable)startTime endTime:(NSString *_Nullable)endTime result:(ResultType _Nullable)result;

// 企业管理者统计界面
+ (void)sanyRequestBossStaticWithStartTime:(NSString *_Nullable)startTime endTime:(NSString *_Nullable)endTime result:(ResultType _Nullable)result;
// 当日每辆车的趟次情况
+ (void)sanyRequestBossVechileWithStartTime:(NSString *_Nullable)startTime endTime:(NSString *_Nullable)endTime result:(ResultType _Nullable)result;
// 当月每天的趟次
+ (void)sanyRequestBossDayCountWithStartTime:(NSString *_Nullable)startTime endTime:(NSString *_Nullable)endTime result:(ResultType _Nullable)result;
// 当年每月的趟次
+ (void)sanyRequestBossMonthCountWithStartTime:(NSString *_Nullable)startTime endTime:(NSString *_Nullable)endTime result:(ResultType _Nullable)result;
// 按报警信息
+ (void)sanyRequestBossAlarmWithStartTime:(NSString *_Nullable)startTime endTime:(NSString *_Nullable)endTime result:(ResultType _Nullable)result;
// 按报警类型统计
+ (void)sanyRequestBossAlarmByTypeWithStartTime:(NSString *_Nullable)startTime endTime:(NSString *_Nullable)endTime result:(ResultType _Nullable)result;
// 按报警车辆统计
+ (void)sanyRequestBossAlarmByVechileWithStartTime:(NSString *_Nullable)startTime endTime:(NSString *_Nullable)endTime result:(ResultType _Nullable)result;
// 管理者 禁区
+ (void)sanyRequestFobZoneResult:(ResultType _Nullable)result;
// 管理者 限速圈
+ (void)sanyRequestLimCircleResult:(ResultType _Nullable)result;
// 车辆列表
+ (void)sanyRequestCarListStartTime:(NSString *_Nullable)startTime endTime:(NSString *_Nullable)endTime result:(ResultType _Nullable)result;
// 绘制地图前列表请求界面
+ (void)sanyRequestDrawListWithType:(NSInteger)type result:(ResultType _Nullable)result;
// 绘制地图后上传接口
+ (void)sanyRequestDrawData:(NSString *_Nullable)efNo locations:(NSString *_Nullable)locations result:(ResultType _Nullable)result;
/**
 *  执法者获取待处理违章数量
 *
 *  @param staffId 执法者id
 *  @param result  请求结果
 */
+ (void)sanyGetAlarmCountByStaffId:(NSString *_Nullable)staffId result:(ResultType _Nullable)result;
/**
 *  执法者获取待处理违章的详情数据
 *
 *  @param staffId 执法者id
 *  @param result  请求结果
 */
+ (void)sanyGetAlarmDetailByStaffId:(NSString *_Nullable)staffId result:(ResultType _Nullable)result;
/**
 *  执法者上传照片接口
 *
 *  @param image  image数据
 *  @param result 上传结果
 */
+ (void)sanyUploadImage:(UIImage *_Nullable)image result:(ResultType _Nullable)result;
/**
 *  监控界面的运输公司及车辆列表
 *
 *  @param result 请求结果
 */
+ (void)sanyMonitorList:(ResultType _Nullable)result;
/**
 *  监控界面车辆详情显示
 *
 *  @param phoneNum 电话号码
 *  @param result 请求结果
 */
+ (void)sanyVehicleDetailWithPhoneNum:(NSString *_Nullable)phoneNum result:(ResultType _Nullable)result;

/**
 *  待审核工程
 *
 *  @param result 请求结果
 */
+ (void)sanyCheckProjectResult:(ResultType _Nullable)result;
/**
 *  同意待审核工程
 *
 *  @param piId   对应工地id
 *  @param result 请求结果返回
 */
+ (void)agreeProjectWithPiId:(NSString *_Nullable)piId result:(ResultType _Nullable)result;
/**
 *  拒绝待审核工程
 *
 *  @param piId   对应工地id
 *  @param result 请求结果返回
 */
+ (void)rejectProjectWithPiId:(NSString *_Nullable)piId result:(ResultType _Nullable)result;
/**
 *  待审核工程车辆列表请求
 *
 *  @param piId   对应工地id
 *  @param result 请求结果返回值
 */
+ (void)projectVehiWithPiId:(NSString *_Nullable)piId result:(ResultType _Nullable)result;
/**
 *  待审核工程路线请求
 *
 *  @param piId   对应工地id
 *  @param result 请求结果返回值
 */
+ (void)projectRouteWithPiId:(NSString *_Nullable)piId result:(ResultType _Nullable)result;
/**
 *  待审核工程工地区域请求
 *
 *  @param worksiteId 对应工地的id
 *  @param result     请求结果返回值
 */
+ (void)projectWorkSiteWithWorkSiteId:(NSString *_Nullable)worksiteId result:(ResultType _Nullable)result;

// 司机首页信息
+ (void)sanyRequestCertMainResult:(ResultType _Nullable)result;
// 路线规划信息
+ (void)sanyRouteById:(NSString *_Nullable)routeId result:(ResultType _Nullable)result;
// 工地位置信息
+ (void)sanyWorkSiteWithId:(NSString *_Nullable)efId result:(ResultType _Nullable)result;
// 司机趟次列表
+ (void)sanyTripTimesWith:(NSString *_Nullable)startTime endTime:(NSString *_Nullable)endTime result:(ResultType _Nullable)result;
// 当日趟次
+ (void)sanyDayTimesWith:(NSString *_Nullable)startTime endTime:(NSString *_Nullable)endTime result:(ResultType _Nullable)result;
// 当月趟次
+ (void)sanyMonthTimesWith:(NSString *_Nullable)startTime endTime:(NSString *_Nullable)endTime result:(ResultType _Nullable)result;
// 当年趟次
+ (void)sanyYearTimesWith:(NSString *_Nullable)startTime endTime:(NSString *_Nullable)endTime result:(ResultType _Nullable)result;
// 企业工地查询
+ (void)sanyProInfoResult:(ResultType _Nullable)result;
// 工地核准证号查询
+ (void)sanyWorkSiteCertWith:(NSString *_Nullable)efId result:(ResultType _Nullable)result;
// 轨迹查询
+ (void)sanyOrbitWith:(NSString *_Nullable)evVehiNo startTime:(NSString *_Nullable)startTime endTime:(NSString *_Nullable)endTime page:(NSString *_Nullable)page result:(ResultType _Nullable)result;

@end
