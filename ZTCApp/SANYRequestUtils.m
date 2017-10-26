//
//  SANYRequestUtils.m
//  ZTCApp
//
//  Created by zousj on 16/7/15.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SANYRequestUtils.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>

//#define TimeDebug

//#define RequestBoot @"http://www.sy-ac.com/"
#define RequestBoot @"http://mmp.vkeyi.com/"

#define RequestLogin @"mobiledologin.do"
#define RequestMain @"mobile/getInitStatInfo.do"
#define RequestListInfo @"mobile/listWorkedInfo.do"
#define RequestMapInfo @"mobile/listElecFence.do"
#define RequestCarInfo @"mobile/getDevCurData.do"
#define RequestMonitor @"mobile/listAlarmRec.do"
#define RequestCount @"mobile/countAlarmRecByType.do"
#define RequestBossMain @"mobile/getInitStatInfoForEnte.do"
#define RequestAlarm @"mobile/listAlarmRec.do"
#define RequestBStatic @"mobile/getStatPageStatData.do"
#define RequestBVechile @"mobile/getVechileCount.do"
#define RequestBDayCnt @"mobile/getDayCountOfMonth.do"
#define RequestBMonthCnt @"mobile/getMonthCountOfYear.do"
#define RequestBAlarm @"mobile/getAlarmofTypeAndVechile.do"
#define RequestBAlarmType @"mobile/countAlarmRecByType.do"
#define RequestListEle @"mobile/listElecFence.do"
#define RequestListVehi @"mobile/listVehi.do"
#define RequestCertMain @"mobile/getApprCert.do"
#define RequestCertRoute @"mobile/getRouteByRmId.do"
#define RequestWorksite @"mobile/geElecFenceByEfId.do"
#define RequestTimes @"mobile/getStatPageStatDataofStaff.do"
#define RequestDayTimes @"mobile/getTripDetailByStaff.do"
#define RequestMonthTimes @"mobile/getDayCountOfMonthByStaff.do"
#define RequestYearTimes @"mobile/getMonthCountOfYearByStaff.do"
#define RequestProInfo @"mobile/getProjectInfoByPITranUnit.do"
#define RequestCert @"mobile/getApprCertOfBoss.do"
#define RequestOrbit @"mobile/queryHistoryTrace.do"
#define RequestDrawList @"mobile/getElecfenceListOfEftype.do"
#define RequestDrawData @"mobile/updateEfMapCoordinates"
#define RequestCheckList @"mobile/listProj.do"
#define RequestAgreeProj @"mobile/projAgree.do"
#define RequestRejectProj @"mobile/rejectProj.do"
#define RequestProjVehi @"mobile/listProjVehi.do"
#define RequestProjRoute @"mobile/getCfByPiId.do"
#define RequestWorkSiteNew @"mobile/getWorkSiteByWsNew.do"
#define RequestMonitorList @"mobile/listVehicleForRtm.do"
#define RequestVehicleList @"mobile/getDevCurData.do"
#define RequestAlarmCount @"mobile/getAlarmCountByStaffId.do"
#define RequestAlarmDetail @"mobile/getAlarmRecDetail.do"
#define RequestUploadPicture @"mobile/uploadPicture.do"

@implementation SANYRequestUtils

+ (void)sanyRequestLoginWithUserCode:(NSString *)userCode
                            password:(NSString *)password
                              result:(ResultType)result {
    NSString *path = [NSString stringWithFormat:@"%@%@", RequestBoot, RequestLogin];
    NSDictionary *para = @{
        @"user_code" : userCode,
        @"password" : [self md5HexDigest:password]
    };
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic[@"data"], nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyRequestMainWithStartTime:(NSString *)startTime
                             endTime:(NSString *)endTime
                              result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestMain];
    NSDictionary *para = [self timeFormat:startTime endTime:endTime];
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyRequestListInfoWithStartTime:(NSString *)startTime
                                 endTime:(NSString *)endTime
                                    type:(SanyInfoType)type
                                  result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestListInfo];
    NSMutableDictionary *para = [NSMutableDictionary
        dictionaryWithDictionary:[self timeFormat:startTime endTime:endTime]];
    [para setObject:@(type) forKey:@"type"];
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败😭"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyRequestMapInfoWithMapInfo:(NSDictionary *)mapInfo
                                 type:(SanyInfoType)type
                               result:(ResultType)result {
    NSString *path;
    NSDictionary *para;
    if (type == SanyInfoTypeCar) {
        NSString *phoneNum = mapInfo[@"phoneNum"];
        if (phoneNum == nil) {
            phoneNum = mapInfo[@"evPhoneNum"];
        }
        para = @{ @"mVLicensePlateList" : phoneNum };
        path = [NSString stringWithFormat:@"%@%@", RequestBoot, RequestCarInfo];
    } else {
        para = @{ @"ef_no" : mapInfo[@"mapId"] };
        path = [NSString stringWithFormat:@"%@%@", RequestBoot, RequestMapInfo];
    }
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"结果为空"
                                        code:2001
                                    userInfo:nil];
                NSLog(@"path:%@,para:%@", path, para);
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyRequestCountWithStartTime:(NSString *)startTime
                              endTime:(NSString *)endTime
                               result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestCount];
    NSDictionary *para = [self timeFormat:startTime endTime:endTime];
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyRequestMonitorWithStartTime:(NSString *)startTime
                                endTime:(NSString *)endTime
                                  carNo:(NSString *)carNo
                                 result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestMonitor];
    NSMutableDictionary *para = [NSMutableDictionary
        dictionaryWithDictionary:[self timeFormat:startTime endTime:endTime]];
    if (carNo != nil) {
        [para setObject:carNo forKey:@"evVehiNo"];
    }

    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyRequestBossMainWithStartTime:(NSString *)startTime
                                 endTime:(NSString *)endTime
                                  result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestBossMain];
    NSDictionary *para = [self timeFormat:startTime endTime:endTime];
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyRequestAlarmStartTime:(NSString *)startTime
                          endTime:(NSString *)endTime
                           result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestAlarm];
    NSDictionary *para = [self timeFormat:startTime endTime:endTime];
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyRequestBossStaticWithStartTime:(NSString *)startTime
                                   endTime:(NSString *)endTime
                                    result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestBStatic];
    NSDictionary *para = [self timeFormat:startTime endTime:endTime];
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyRequestBossVechileWithStartTime:(NSString *)startTime
                                    endTime:(NSString *)endTime
                                     result:(ResultType)result {
    NSString *path = [NSString stringWithFormat:@"%@%@", RequestBoot, RequestBVechile];
    NSDictionary *para = [self timeFormat:startTime endTime:endTime];
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyRequestBossDayCountWithStartTime:(NSString *)startTime
                                     endTime:(NSString *)endTime
                                      result:(ResultType)result {
    NSString *path = [NSString stringWithFormat:@"%@%@", RequestBoot, RequestBDayCnt];
    NSDictionary *para = [self timeFormat:startTime endTime:endTime];
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyRequestBossMonthCountWithStartTime:(NSString *)startTime
                                       endTime:(NSString *)endTime
                                        result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestBMonthCnt];
    NSDictionary *para = [self timeFormat:startTime endTime:endTime];
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyRequestBossAlarmWithStartTime:(NSString *)startTime
                                  endTime:(NSString *)endTime
                                   result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestBAlarm];
    NSDictionary *para = [self timeFormat:startTime endTime:endTime];
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyRequestBossAlarmByTypeWithStartTime:(NSString *)startTime
                                        endTime:(NSString *)endTime
                                         result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestBAlarmType];
    NSMutableDictionary *para = [NSMutableDictionary
        dictionaryWithDictionary:[self timeFormat:startTime endTime:endTime]];
    [para setObject:@"0" forKey:@"type"];
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyRequestBossAlarmByVechileWithStartTime:(NSString *)startTime
                                           endTime:(NSString *)endTime
                                            result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestBAlarmType];
    NSMutableDictionary *para = [NSMutableDictionary
        dictionaryWithDictionary:[self timeFormat:startTime endTime:endTime]];
    [para setObject:@"1" forKey:@"type"];
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyRequestCertMainResult:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestCertMain];
    [[self httpManager] GET:path
        parameters:nil
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

// 车辆路径
+ (void)sanyRouteById:(NSString *)routeId result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestCertRoute];
    NSDictionary *para = @{ @"rmId" : routeId };
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result([resDic[@"rows"] firstObject], nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

// 工地位置获取
+ (void)sanyWorkSiteWithId:(NSString *)efId result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestWorksite];
    NSDictionary *para = @{ @"efId" : efId };
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result([resDic[@"rows"] firstObject], nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

// 工地相关核准证号
+ (void)sanyWorkSiteCertWith:(NSString *)efId result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestCert];
    NSDictionary *para = @{ @"piId" : efId };
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

// 趟次获取
+ (void)sanyTripTimesWith:(NSString *)startTime
                  endTime:(NSString *)endTime
                   result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestTimes];
    NSDictionary *para = [self timeFormat:startTime endTime:endTime];
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

// 当日趟次
+ (void)sanyDayTimesWith:(NSString *)startTime
                 endTime:(NSString *)endTime
                  result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestDayTimes];
    NSDictionary *para = [self timeFormat:startTime endTime:endTime];
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err = [NSError errorWithDomain:@"登陆失败"
                                                   code:2001
                                               userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

// 当月趟次
+ (void)sanyMonthTimesWith:(NSString *)startTime
                   endTime:(NSString *)endTime
                    result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestMonthTimes];
    NSDictionary *para = [self timeFormat:startTime endTime:endTime];
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

// 当年趟次
+ (void)sanyYearTimesWith:(NSString *)startTime
                  endTime:(NSString *)endTime
                   result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestYearTimes];
    NSDictionary *para = [self timeFormat:startTime endTime:endTime];
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

// 禁区
+ (void)sanyRequestFobZoneResult:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestListEle];
    NSDictionary *para = @{ @"ef_type" : @4 };
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}
// 限速圈
+ (void)sanyRequestLimCircleResult:(ResultType)result {
    NSString *path = [NSString stringWithFormat:@"%@%@", RequestBoot, RequestListEle];
    NSDictionary *para = @{ @"ef_no" : @5 };
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {
        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyGetAlarmCountByStaffId:(NSString *)staffId result:(ResultType)result {
    NSString *path = [NSString stringWithFormat:@"%@%@", RequestBoot, RequestAlarmCount];
    NSDictionary *para = @{ @"staffId" : staffId };
    [self.httpManager GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err = [NSError errorWithDomain:@"请求失败"
                                                   code:2001
                                               userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyGetAlarmDetailByStaffId:(NSString *_Nullable)staffId result:(ResultType _Nullable)result {
    NSString *path = [NSString stringWithFormat:@"%@%@", RequestBoot, RequestAlarmDetail];
    NSDictionary *para = @{ @"staffId" : staffId };
    [self.httpManager GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err = [NSError errorWithDomain:@"请求失败"
                                                   code:2001
                                               userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyUploadImage:(UIImage *)image result:(ResultType)result {
    NSString *path = [NSString stringWithFormat:@"%@%@", RequestBoot, RequestUploadPicture];
    [self.httpManager POST:path
        parameters:nil
        constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
            // 获取图片数据
            NSData *fileData = UIImagePNGRepresentation(image);

            // 设置上传图片的名字
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];

            [formData appendPartWithFileData:fileData name:@"uploadDraw" fileName:fileName mimeType:@"image/png"];

        }
        progress:^(NSProgress *_Nonnull uploadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyCheckProjectResult:(ResultType)result {
    NSString *path = [NSString stringWithFormat:@"%@%@", RequestBoot, RequestCheckList];
    NSDictionary *para = @{ @"piStatus" : @2 };
    [self.httpManager GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err = [NSError errorWithDomain:@"登陆失败"
                                                   code:2001
                                               userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)agreeProjectWithPiId:(NSString *)piId result:(ResultType)result {
    NSString *path = [NSString stringWithFormat:@"%@%@", RequestBoot, RequestAgreeProj];
    NSDictionary *para = @{ @"piId" : piId };
    [self.httpManager GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err = [NSError errorWithDomain:@"登陆失败"
                                                   code:2001
                                               userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)rejectProjectWithPiId:(NSString *)piId result:(ResultType)result {
    NSString *path = [NSString stringWithFormat:@"%@%@", RequestBoot, RequestRejectProj];
    NSDictionary *para = @{ @"piId" : piId };
    [self.httpManager GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err = [NSError errorWithDomain:@"登陆失败"
                                                   code:2001
                                               userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)projectVehiWithPiId:(NSString *)piId result:(ResultType)result {
    NSString *path = [NSString stringWithFormat:@"%@%@", RequestBoot, RequestProjVehi];
    NSDictionary *para = @{ @"piId" : piId };
    [self.httpManager GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err = [NSError errorWithDomain:@"登陆失败"
                                                   code:2001
                                               userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)projectRouteWithPiId:(NSString *)piId result:(ResultType)result {
    NSString *path = [NSString stringWithFormat:@"%@%@", RequestBoot, RequestProjRoute];
    NSDictionary *para = @{ @"piId" : piId };
    [self.httpManager GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err = [NSError errorWithDomain:@"登陆失败"
                                                   code:2001
                                               userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)projectWorkSiteWithWorkSiteId:(NSString *)worksiteId result:(ResultType)result {
    NSString *path = [NSString stringWithFormat:@"%@%@", RequestBoot, RequestWorkSiteNew];
    NSDictionary *para = @{ @"ws" : worksiteId };
    [self.httpManager GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err = [NSError errorWithDomain:@"😲请求错误😲"
                                                   code:2001
                                               userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyMonitorList:(ResultType)result {
    NSString *path = [NSString stringWithFormat:@"%@%@", RequestBoot, RequestMonitorList];
    NSDictionary *para = nil;
    [self.httpManager GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err = [NSError errorWithDomain:@"😲请求失败😲"
                                                   code:2001
                                               userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

+ (void)sanyVehicleDetailWithPhoneNum:(NSString *)phoneNum result:(ResultType)result {
    NSString *path = [NSString stringWithFormat:@"%@%@", RequestBoot, RequestVehicleList];
    [[self httpManager] GET:path
        parameters:@{ @"phoneNum" : phoneNum }
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                resDic = @{
                    @"devAry" : @[
                        @{
                           @"dataAry" : @{
                               @"alramInfo" : @"00000000",
                               @"angle" : @"303",
                               @"beanAlarmInfo" : @{
                                   @"ECUCheat" : @"1",
                                   @"alarmInfo" : @0,
                                   @"cameraFault" : @"0",
                                   @"driveOverTime" : @"0",
                                   @"driveTime" : @"1",
                                   @"emergencyAlarm" : @"0",
                                   @"emptyHeavyCarCheat" : @"0",
                                   @"fatigueDriving" : @"0",
                                   @"gnssAntennaBreak" : @"1",
                                   @"gnssAntennaFault" : @"1",
                                   @"gnssFault" : @"1",
                                   @"illegalRise" : @"1",
                                   @"illegalityFire" : @"1",
                                   @"illegalityMove" : @"0",
                                   @"inoutArea" : @"0",
                                   @"inoutPath" : @"1",
                                   @"iolMassAbr" : @"1",
                                   @"isStolen" : @"1",
                                   @"lcdFault" : @"1",
                                   @"noGpsSignal" : @"1",
                                   @"openCloseBoxCheat" : @"0",
                                   @"packingOverTime" : @"0",
                                   @"pathDeviate" : @"0",
                                   @"riseCheat" : @"0",
                                   @"speedingAlarm" : @"1",
                                   @"terminalOutage" : @"0",
                                   @"terminalUndervoltage" : @"0",
                                   @"ttsFault" : @"0",
                                   @"turnOnOneSide" : @"0",
                                   @"vssFault" : @"0",
                                   @"warning" : @"0"
                               },
                               @"beanCsAlarmExtInfo" : @"",
                               @"beanJcAlarmExtInfo" : @"",
                               @"beanLxAlarmExtInfo" : @"",
                               @"beanStatusInfo" : @{
                                   @"accState" : @"1",
                                   @"backDoor" : @"0",
                                   @"cabDoor" : @"0",
                                   @"centreDoor" : @"0",
                                   @"fixedPosi" : @"0",
                                   @"frontDoor" : @"0",
                                   @"isBigDipperPosi" : @"1",
                                   @"isGLONASSPosi" : @"0",
                                   @"isGPSPosi" : @"0",
                                   @"isGalileoPosi" : @"0",
                                   @"latitudeType" : @"1",
                                   @"loadState" : @"1",
                                   @"loadsState" : @"00",
                                   @"longitudeType" : @"1",
                                   @"ohterDoor" : @"0",
                                   @"operarorState" : @"1",
                                   @"posiIsEncryption" : @"1",
                                   @"riseState" : @"1",
                                   @"statusInfo" : @189,
                                   @"tarpaulinState" : @"0"
                               },
                               @"can_engineSpeed" : @"",
                               @"can_engineState" : @"",
                               @"can_vehicleSpeed" : @"",
                               @"csAlarmExtInfo" : @"",
                               @"currStateId" : @1,
                               @"elevation" : @"100",
                               @"engineFaultInfo" : @"",
                               @"engineStart" : @0,
                               @"ext" : @0,
                               @"gpsTime" : @"2016-12-01 14: 36: 57",
                               @"jcAlarmExtInfo" : @"",
                               @"latitude" : @"28.302918",
                               @"longitude" : @"112.915934",
                               @"lxAlarmExtInfo" : @"",
                               @"mapLatitude" : @"28.29939396",
                               @"mapLongitude" : @"112.9213582",
                               @"mapPosition" : @"湖南省长沙市望城区;筲箕山,道士冲附近",
                               @"mileage" : @"",
                               @"oilmass" : @"",
                               @"online" : @0,
                               @"phoneNum" : @"15395034904",
                               @"serverTime" : @"2016-12-0114: 36: 58.0",
                               @"speed" : @"36.2",
                               @"statusInfo" : @"000000BD",
                               @"vehicleSpeed" : @""
                           },
                           @"devid" : @"15395034904"
                        }
                    ]
                };
                result(resDic, nil);
                /*
                NSError *err =
                    [NSError errorWithDomain:@"😲请求失败😲"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
                 */
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

// 车辆列表
+ (void)sanyRequestCarListStartTime:(NSString *)startTime
                            endTime:(NSString *)endTime
                             result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestListVehi];
    NSDictionary *dic = [self timeFormat:startTime endTime:endTime];
    NSMutableDictionary *para =
        [NSMutableDictionary dictionaryWithDictionary:dic];
    [para setObject:@1 forKey:@"type"];
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

// 企业所有项目信息
+ (void)sanyProInfoResult:(ResultType)result {
    NSString *path = [NSString stringWithFormat:@"%@%@", RequestBoot, RequestProInfo];
    [[self httpManager] GET:path
        parameters:nil
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

// 轨迹图
+ (void)sanyOrbitWith:(NSString *)evVehiNo
            startTime:(NSString *)startTime
              endTime:(NSString *)endTime
                 page:(NSString *)page
               result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestOrbit];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSDictionary *para = @{
        @"evVehiNo" : evVehiNo,
        @"startTime" : startTime,
        @"endTime" : endTime,
        @"datetime" : [NSString stringWithFormat:@"%f", time * 1000],
        @"page" : page,
        @"pagesize" : @"50000"
    };
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"登陆失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

// 请求所画圈地列表
+ (void)sanyRequestDrawListWithType:(NSInteger)type result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestDrawList];
    NSDictionary *para = @{ @"efType" : @(type) };
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"请求失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

// 上传轨迹数据
+ (void)sanyRequestDrawData:(NSString *)efNo
                  locations:(NSString *)locations
                     result:(ResultType)result {
    NSString *path =
        [NSString stringWithFormat:@"%@%@", RequestBoot, RequestDrawData];
    NSDictionary *para = @{ @"ef_no" : efNo,
                            @"ef_mapCoordinates" : locations };
    [[self httpManager] GET:path
        parameters:para
        progress:^(NSProgress *_Nonnull downloadProgress) {

        }
        success:^(NSURLSessionDataTask *_Nonnull task,
                  id _Nullable responseObject) {
            NSDictionary *resDic =
                [NSJSONSerialization JSONObjectWithData:responseObject
                                                options:NSJSONReadingAllowFragments
                                                  error:nil];
            if (resDic != nil) {
                result(resDic, nil);
            } else {
                NSError *err =
                    [NSError errorWithDomain:@"请求失败"
                                        code:2001
                                    userInfo:nil];
                result(nil, err);
            }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            result(nil, error);
        }];
}

#pragma mark - private
+ (AFHTTPSessionManager *)httpManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    return manager;
}

+ (NSString *)md5HexDigest:(NSString *)input {
    const char *str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret =
        [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2]; //

    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    return ret;
}

/**
 * startTime的值如果小于endTime的值，两个时间值都取当天的
 * startTime的值如果大于endTime的值，startTime取前一天的值，endTime取当天的值
 * 时间格式化为 YYYY-MM-dd+HH:mm:ss
 */
+ (NSDictionary *)timeFormat:(NSString *)startTime endTime:(NSString *)endTime {
    NSInteger startValue =
        [[startTime componentsSeparatedByString:@":"] firstObject].integerValue;
    NSInteger endValue =
        [[endTime componentsSeparatedByString:@":"] firstObject].integerValue;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
#ifdef TimeDebug
    NSString *currentDate = @"2016-07-13";
    NSString *beforeDate = @"2016-07-12";
#else
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *beforeDate = [dateFormatter
        stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24]];
#endif
    NSDictionary *timeDic = nil;
    if (endValue > startValue) {
        timeDic = @{
            @"startTime" :
                [NSString stringWithFormat:@"%@+%@:00", currentDate, startTime],
            @"endTime" : [NSString stringWithFormat:@"%@+%@:00", currentDate, endTime]
        };
    } else {
        timeDic = @{
            @"startTime" :
                [NSString stringWithFormat:@"%@+%@:00", beforeDate, startTime],
            @"endTime" : [NSString stringWithFormat:@"%@+%@:00", currentDate, endTime]
        };
    }
    return timeDic;
}

@end
