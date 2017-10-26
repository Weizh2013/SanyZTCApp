//
//  SubmitTableViewCell.h
//  ZTCApp
//
//  Created by 魏宙辉 on 17/1/23.
//  Copyright © 2017年 Sany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitTableViewCell : UITableViewCell

- (void)addTarget:(id)target selector:(SEL)selector;

- (IBAction)submitButtonClicked:(id)sender;

@end
