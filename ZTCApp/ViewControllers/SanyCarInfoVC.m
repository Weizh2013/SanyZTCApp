//
//  SanyCarInfoVC.m
//  ZTCApp
//
//  Created by zousj on 16/11/1.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyCarInfoVC.h"
#import "SanyCarInfoTableViewCell.h"
#import "Masonry.h"

@interface SanyCarInfoVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *_carInfoTV;
    UIButton        *_orbitBt;
    UITextField     *_speedTF;
    UIDatePicker    *_datePicker;
    UIView          *_datePickerView;
    UIButton        *_startBt;
    UIButton        *_endBt;
    
    NSDate      *_startDate;
    NSDate      *_endDate;
    
    NSArray     *_carInfoList;
    BOOL        _isStartSetting;
}
@end

@implementation SanyCarInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInit];
    [self viewInit];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)dataInit {
    _carInfoList = @[@"SIM卡手机号",@"重载状态",@"篷布状态",@"举升状态",@"地址",@"GPS定位时间"];
    _startDate = nil;
    _endDate = nil;
}

- (void)viewInit {
    self.navigationItem.title = self.carNo;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _carInfoTV = [[UITableView alloc]init];
    [self.view addSubview:_carInfoTV];
    [_carInfoTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(6*44.0);
    }];
    [_carInfoTV registerNib:[UINib nibWithNibName:@"SanyCarInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"SanyCarInfoTableViewCell"];
    _carInfoTV.scrollEnabled = NO;
    _carInfoTV.allowsSelection = NO;
    _carInfoTV.dataSource = self;
    _carInfoTV.delegate = self;
    
    _orbitBt = [UIButton buttonWithType:UIButtonTypeSystem];
    _orbitBt.layer.masksToBounds = YES;
    _orbitBt.layer.cornerRadius = 5.0f;
    [self.view addSubview:_orbitBt];
    [_orbitBt setTitle:@"历史轨迹查询" forState:UIControlStateNormal];
    [_orbitBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_orbitBt setFont:[UIFont systemFontOfSize:20.0f]];
    _orbitBt.backgroundColor = [UIColor blueColor];
    [_orbitBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(-40);
        make.height.left.mas_equalTo(40);
    }];
    [_orbitBt addTarget:self action:@selector(toOrbit:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *speedLb = [[UILabel alloc]init];
    speedLb.text = @"速度";
    [self.view addSubview:speedLb];
    [speedLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_orbitBt.mas_top).offset(-5);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *endLb = [[UILabel alloc]init];
    endLb.text = @"结束时间";
    [self.view addSubview:endLb];
    [endLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(speedLb.mas_top).offset(-5);
        make.left.width.height.equalTo(speedLb);
    }];
    _endBt = [UIButton buttonWithType:UIButtonTypeSystem];
    _endBt.layer.cornerRadius = 3.0f;
    _endBt.layer.masksToBounds = YES;
    _endBt.layer.borderColor = [UIColor grayColor].CGColor;
    _endBt.layer.borderWidth = 1.0f;
    [self.view addSubview:_endBt];
    [_endBt setTitle:@"请选择结束时间" forState:UIControlStateNormal];
    _endBt.backgroundColor = [UIColor whiteColor];
    [_endBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_endBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(endLb.mas_right).offset(5);
        make.top.bottom.equalTo(endLb);
        make.right.mas_equalTo(-5);
    }];
    [_endBt addTarget:self action:@selector(endTimeSelect) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *startLb = [[UILabel alloc]init];
    startLb.text = @"开始时间";
    [self.view addSubview:startLb];
    [startLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(endLb.mas_top).offset(-5);
        make.left.width.height.equalTo(speedLb);
    }];
    _startBt = [UIButton buttonWithType:UIButtonTypeSystem];
    _startBt.layer.cornerRadius = 3.0f;
    _startBt.layer.masksToBounds = YES;
    _startBt.layer.borderColor = [UIColor grayColor].CGColor;
    _startBt.layer.borderWidth = 1.0f;
    [self.view addSubview:_startBt];
    [_startBt setTitle:@"请选择开始时间" forState:UIControlStateNormal];
    _startBt.backgroundColor = [UIColor whiteColor];
    [_startBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_startBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startLb.mas_right).offset(5);
        make.top.bottom.equalTo(startLb);
        make.right.mas_equalTo(-5);
    }];
    [_startBt addTarget:self action:@selector(startTimeSelect) forControlEvents:UIControlEventTouchUpInside];
    
    _speedTF = [[UITextField alloc]init];
    _speedTF.layer.borderColor = [UIColor grayColor].CGColor;
    _speedTF.keyboardType = UIKeyboardTypeNumberPad;
    _speedTF.layer.borderWidth = 1.0f;
    _speedTF.layer.cornerRadius = 5.0f;
    _speedTF.layer.masksToBounds = YES;
    [self.view addSubview:_speedTF];
    [_speedTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(speedLb);
        make.left.equalTo(speedLb.mas_right).offset(5);
        make.width.mas_equalTo(100);
    }];
    UILabel *lb = [[UILabel alloc]init];
    [self.view addSubview:lb];
    lb.text = @"ms";
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_speedTF);
        make.left.equalTo(_speedTF.mas_right);
        make.width.mas_equalTo(50);
    }];
    
    _datePickerView = [[UIView alloc]init];
    _datePickerView.hidden = YES;
    _datePickerView.layer.cornerRadius = 5.0f;
    _datePickerView.layer.masksToBounds = YES;
    _datePickerView.layer.borderWidth = 5.0f;
    _datePickerView.layer.borderColor = [UIColor grayColor].CGColor;
    _datePickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_datePickerView];
    [_datePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(100);
        make.bottom.mas_equalTo(-100);
    }];
    
    _datePicker = [[UIDatePicker alloc]init];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    _datePicker.maximumDate = [NSDate date];
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_datePickerView addSubview:_datePicker];
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
    
    UIButton *dateSureBt = [UIButton buttonWithType:UIButtonTypeSystem];
    dateSureBt.layer.cornerRadius = 3.0f;
    dateSureBt.layer.masksToBounds = YES;
    [_datePickerView addSubview:dateSureBt];
    [dateSureBt setTitle:@"确定" forState:UIControlStateNormal];
    dateSureBt.backgroundColor = [UIColor blueColor];
    [dateSureBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dateSureBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(60);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(30);
    }];
    [dateSureBt addTarget:self action:@selector(dateSureBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *dateCancelBt = [UIButton buttonWithType:UIButtonTypeSystem];
    dateCancelBt.layer.cornerRadius = 3.0f;
    dateCancelBt.layer.masksToBounds = YES;
    [_datePickerView addSubview:dateCancelBt];
    [dateCancelBt setTitle:@"取消" forState:UIControlStateNormal];
    dateCancelBt.backgroundColor = [UIColor blueColor];
    [dateCancelBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dateCancelBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.width.mas_equalTo(60);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(30);
    }];
    [dateCancelBt addTarget:self action:@selector(dateCancelBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)dateSureBtClicked:(UIButton *)sender {
    _datePickerView.hidden = YES;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSString *dateStr = [df stringFromDate:_datePicker.date];
    if (_isStartSetting) {
        _startDate = _datePicker.date;
        [_startBt setTitle:dateStr forState:UIControlStateNormal];
    }else {
        _endDate = _datePicker.date;
        [_endBt setTitle:dateStr forState:UIControlStateNormal];
    }
}

- (void)dateCancelBtClicked:(UIButton *)sender {
    _datePickerView.hidden = YES;
}

- (void)startTimeSelect {
    if (_endDate == nil) {
        _datePicker.maximumDate = [NSDate date];
        _datePicker.minimumDate = nil;
    }else {
        _datePicker.maximumDate = _endDate;
        _datePicker.minimumDate = nil;
    }
    _datePickerView.hidden = NO;
    _isStartSetting = YES;
}

- (void)endTimeSelect {
    if (_startDate == nil) {
        _datePicker.maximumDate = [NSDate date];
        _datePicker.minimumDate = nil;
    }else {
        _datePicker.maximumDate = [NSDate date];
        _datePicker.minimumDate = _startDate;
    }
    _datePickerView.hidden = NO;
    _isStartSetting = NO;
}

- (void)toOrbit:(UIButton *)sender {
    self.bossMonitorVC.startTime    = _startBt.titleLabel.text;
    self.bossMonitorVC.endTime      = _endBt.titleLabel.text;
    self.bossMonitorVC.speed        = _speedTF.text;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_speedTF resignFirstResponder];
}

#pragma mark - <键盘>

#define INTERVAL_KEYBOARD 10
///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (self.view.frame.size.height-40.0f+INTERVAL_KEYBOARD) - (self.view.frame.size.height - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

#pragma mark - <delegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _carInfoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SanyCarInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SanyCarInfoTableViewCell"];
    switch (indexPath.row) {
        case 0:{
            [cell bindCellWithMainTitle:_carInfoList[indexPath.row] subTitle:_carInfo[@"phoneNum"]];
            break;
        }
        case 1:{
            NSString *status = [_carInfo[@"beanStatusInfo"][@"loadState"]integerValue]?@"有载重":@"无载重";
            [cell bindCellWithMainTitle:_carInfoList[indexPath.row] subTitle:status];
            break;
        }
        case 2:{
            NSString *status = [_carInfo[@"beanStatusInfo"][@"tarpaulinState"]integerValue]?@"开启":@"关闭";
            [cell bindCellWithMainTitle:_carInfoList[indexPath.row] subTitle:status];
            break;
        }
        case 3:{
            NSString *status = [_carInfo[@"beanStatusInfo"][@"riseState"]integerValue]?@"开启":@"关闭";
            [cell bindCellWithMainTitle:_carInfoList[indexPath.row] subTitle:status];
            break;
        }
        case 4:
            [cell bindCellWithMainTitle:_carInfoList[indexPath.row] subTitle:_carInfo[@"mapPosition"]];
            break;
        case 5:
            [cell bindCellWithMainTitle:_carInfoList[indexPath.row] subTitle:_carInfo[@"serverTime"]];
        default:
            break;
    }
    return cell;
}

@end
