//
//  SanyManagerAboutVC.m
//  ZTCApp
//
//  Created by zousj on 16/6/28.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanyManagerAboutVC.h"
#import "Masonry.h"
#import "SanyDrawListVC.h"
#import "SanyToolCollectionViewCell.h"

@interface SanyManagerAboutVC ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSArray *_dataBuf;
}
@end

@implementation SanyManagerAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
    [self dataInit];
}

- (void)viewInit {
    self.navigationItem.title = @"工具";
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake(SCREENWIDTH / 4, SCREENWIDTH / 4 + 40.0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"SanyToolCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"toolCell"];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(74);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-55);
    }];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
}

- (void)dataInit {
    _dataBuf = @[ @{
                     @"imgName" : @"icon_car_list.jpg",
                     @"btName" : @"绘工地"
                 },
                  @{
                      @"imgName" : @"icon_car_list.jpg",
                      @"btName" : @"绘消纳场"
                  },
                  @{
                      @"imgName" : @"icon_car_list.jpg",
                      @"btName" : @"绘限速圈"
                  } ];
}

#pragma mark delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SanyToolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"toolCell" forIndexPath:indexPath];
    NSDictionary *dic = _dataBuf[indexPath.row];
    [cell bindCellWithImage:dic[@"imgName"] name:dic[@"btName"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    SanyDrawListVC *sanyDrawListVC = [[SanyDrawListVC alloc] init];
    sanyDrawListVC.drawCategory = indexPath.row;
    [self.navigationController pushViewController:sanyDrawListVC animated:YES];
}

@end
