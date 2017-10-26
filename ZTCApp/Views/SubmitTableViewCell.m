//
//  SubmitTableViewCell.m
//  ZTCApp
//
//  Created by 魏宙辉 on 17/1/23.
//  Copyright © 2017年 Sany. All rights reserved.
//

#import "SubmitTableViewCell.h"

@implementation SubmitTableViewCell
{
    id _target;
    SEL _selector;
    __weak IBOutlet UIButton *submitButton;
}

- (void)addTarget:(id)target selector:(SEL)selector {
    if ([_target isEqual:target]) {
        NSLog(@"重复定义");
        return;
    }
    _target = target;
    _selector = selector;
}

- (IBAction)submitButtonClicked:(id)sender {
    [_target performSelector:_selector withObject:submitButton];
}
@end
