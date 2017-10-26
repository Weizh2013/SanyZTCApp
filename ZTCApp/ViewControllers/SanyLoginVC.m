//
//  SanyLoginVC.m
//  ZTCApp
//
//  Created by zousj on 16/6/29.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyLoginVC.h"
#import "AppDelegate.h"
#import "CocoaSecurity.h"

@interface SanyLoginVC ()
{
    NSString *_userName;
    NSString *_password;
}
@end

@implementation SanyLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInit];
    [self viewInit];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dataInit {
    _userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString *passwordStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    _password = [CocoaSecurity aesDecryptWithBase64:passwordStr key:SECRETYKEY].utf8String;
    _passwordTF.secureTextEntry = YES;
    if (_userName != nil && _password != nil) {
        _userNameTF.text = _userName;
        _passwordTF.text = _password;
    }
}

- (void)viewInit {
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    imgView.image = [UIImage imageNamed:@"beijing.jpg"];
    [self.view addSubview:imgView];
    [self.view sendSubviewToBack:imgView];
    
    _loginBt.layer.masksToBounds = YES;
    _loginBt.layer.cornerRadius = 5.0f;
    
    _loginBt.backgroundColor = [UIColor colorWithValue:0x00BFFF alpha:0.5];
    UIColor *backColor = [UIColor colorWithValue:0xF0FFFF alpha:0.8];
    _userNameTF.backgroundColor = backColor;
    _passwordTF.backgroundColor = backColor;
    _userNameLb.backgroundColor = backColor;
    _passwordLb.backgroundColor = backColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_passwordTF resignFirstResponder];
    [_userNameTF resignFirstResponder];
}

- (IBAction)loginBtClicked:(id)sender {
    [_passwordTF resignFirstResponder];
    [_userNameTF resignFirstResponder];
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate *del = app.delegate;
    /// TODO: debug
//    _userNameTF.text = @"zfyh";
//    _passwordTF.text = @"1";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SANYRequestUtils sanyRequestLoginWithUserCode:_userNameTF.text password:_passwordTF.text result:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error==nil) {
            [[NSUserDefaults standardUserDefaults]setObject:_userNameTF.text forKey:@"userName"];
            NSString *passwordStr = [CocoaSecurity aesEncrypt:_passwordTF.text key:SECRETYKEY].base64;
            [[NSUserDefaults standardUserDefaults]setObject:passwordStr forKey:@"password"];
            [[SanyStaffUtil shareUtil]updateUtilWithLoginDic:result];
            if ([SanyStaffUtil shareUtil].type == SanyStaffTypeGovernment) {
                [del managerCtrlsInit];
            }else if ([SanyStaffUtil shareUtil].type == SanyStaffTypeCompany){
                [del bossCtrlsInit];
            }else {
                [del driverCtrlsInit];
            }
        }else {
            [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

#pragma mark - keyboard events -

#define INTERVAL_KEYBOARD 10
///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (_loginBt.frame.origin.y+_loginBt.frame.size.height+INTERVAL_KEYBOARD) - (self.view.frame.size.height - kbHeight);
    
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

@end
