//
//  SanyLoginVC.h
//  ZTCApp
//
//  Created by zousj on 16/6/29.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyBaseVC.h"

@interface SanyLoginVC : SanyBaseVC
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBt;
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@property (weak, nonatomic) IBOutlet UILabel *passwordLb;

- (IBAction)loginBtClicked:(id)sender;

@end
