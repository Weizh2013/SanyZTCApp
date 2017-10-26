//
//  SanySearchBar.h
//  ZTCApp
//
//  Created by zousj on 16/7/4.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SanySearchBarDelegate <NSObject>

@required
- (void)didSearchBarSearchClicked:(NSString *)searchContent;
- (void)didSearchBarMenuClicked;

@end

@interface SanySearchBar : UIView

@property (nonatomic,weak) id <SanySearchBarDelegate> delegate;

@end
