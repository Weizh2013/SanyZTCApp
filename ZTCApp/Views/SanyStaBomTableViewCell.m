//
//  SanyStaBomTableViewCell.m
//  ZTCApp
//
//  Created by zousj on 16/6/29.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyStaBomTableViewCell.h"

@implementation SanyStaBomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

/*
 * managerDic = @{
 *                公司名称：@{
 *                          @"超速报警":@"10",
 *                          @"举升报警":@"5",
 *                          @"越界":@"13"
 *                          }
 *               }
 */
- (void)reloadDataWithManagerDic:(NSDictionary *)managerDic {
    _title1Lb.hidden = NO;
    _title2Lb.hidden = NO;
    _title3Lb.hidden = NO;
    _title4Lb.hidden = NO;
    _para1Lb.hidden = NO;
    _para2Lb.hidden = NO;
    _para3Lb.hidden = NO;
    _para4Lb.hidden = NO;
    NSString        *companyName = managerDic.allKeys.firstObject;
    NSDictionary    *companyDic  = managerDic[companyName];
    _title1Lb.text  = companyName;
    _para1Lb.text   = @"";
    _title2Lb.text  = @"超速报警";
    _para2Lb.text   = companyDic[@"超速报警"];
    _title3Lb.text  = @"举升报警";
    _para3Lb.text   = companyDic[@"举升报警"];
    _title4Lb.text  = @"越界";
    _para4Lb.text   = companyDic[@"越界"];
}
/**
 *      {
 *          "phoneNum": "18773170222",
 *          "startTime": "2016-07-12 20:51:00",
 *          "endTime": "2016-07-12 20:51:00",
 *          "paraId": "30000020",
 *          "paraName": "inoutArea",
 *          "paraCnName": "进出区域",
 *          "areaType": "0",
 *          "areaId": "20000004",
 *          "direction": "0",
 *          "loadState": "0",
 *          "evVehiNo": "湘AZ0002",
 *          "eiName": "运输企业二",
 *          "sfName": "孙健",
 *          "efType": "2",
 *          "paraNameShow": "进工地",
 *          "efName": "德斯勤",
 *          "efZoneType": "1",
 *          "efMapCoordinates": "113.007041,28.111678;113.016311,28.111678;113.016311,28.10759;113.007041,28.10759",
 *      }
 */
- (void)reloadDataWithAlarmDic:(NSDictionary *)alarmDic {
    _title1Lb.hidden = NO;
    _title2Lb.hidden = NO;
    _title3Lb.hidden = NO;
    _title4Lb.hidden = NO;
    _para1Lb.hidden = NO;
    _para2Lb.hidden = NO;
    _para3Lb.hidden = NO;
    _para4Lb.hidden = NO;
    _title1Lb.text  = @"车牌号";
    _para1Lb.text   = alarmDic[@"evVehiNo"];
    _title2Lb.text  = @"司机";
    _para2Lb.text   = alarmDic[@"sfName"];
    _title3Lb.text  = @"报警类型";
    _para3Lb.text   = alarmDic[@"paraCnName"];
    _title4Lb.text  = @"时间";
    NSString *timeStr = alarmDic[@"startTime"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:timeStr];
    dateFormatter.dateFormat = @"MM-dd HH:mm";
    _para4Lb.text = [dateFormatter stringFromDate:date];
}

- (void)clearCell {
    _title1Lb.hidden = YES;
    _title2Lb.hidden = YES;
    _title3Lb.hidden = YES;
    _title4Lb.hidden = YES;
    _para1Lb.hidden = YES;
    _para2Lb.hidden = YES;
    _para3Lb.hidden = YES;
    _para4Lb.hidden = YES;
}

@end
