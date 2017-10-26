//
//  SanyImgSelectorTableViewCell.h
//  ZTCApp
//
//  Created by 魏宙辉 on 17/1/23.
//  Copyright © 2017年 Sany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SanyImgSelectorTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *imgSelectorButton;

- (IBAction)imgSelectorButtonClicked:(id)sender;

- (void)setImageForSelectorButton:(UIImage *)image;

- (void)addTarget:(id)target selector:(SEL)selector;

@end
