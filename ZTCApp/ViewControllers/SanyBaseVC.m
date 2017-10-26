//
//  SanyBaseVC.m
//  ZTCApp
//
//  Created by zousj on 16/6/28.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyBaseVC.h"

@interface SanyBaseVC ()

@end

@implementation SanyBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title = @"";
    self.navigationItem.backBarButtonItem = backbutton;
    self.view.backgroundColor = [UIColor colorWithValue:0xf0f0f0 alpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
