//
//  SanyToolCollectionViewCell.h
//  ZTCApp
//
//  Created by zousj on 16/12/28.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SanyToolCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *btImage;
@property (weak, nonatomic) IBOutlet UILabel *btName;

- (void)bindCellWithImage:(NSString *)imageName name:(NSString *)name;

@end
