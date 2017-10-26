//
//  SanySearchBar.m
//  ZTCApp
//
//  Created by zousj on 16/7/4.
//  Copyright © 2016年 Sany. All rights reserved.
//

#import "SanySearchBar.h"
#import "Masonry.h"

@interface SanySearchBar () <UISearchBarDelegate>

@end

@implementation SanySearchBar
{
    UISearchBar *_searchBar;
    UIButton    *_searchBt;
    UIButton    *_listBt;
}


- (instancetype)init {
    if (self = [super init]) {
        _listBt = [UIButton buttonWithType:UIButtonTypeSystem];
        [_listBt setTitle:@"菜单" forState:UIControlStateNormal];
        [_listBt addTarget:self action:@selector(listBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_listBt];
        [_listBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(3);
            make.bottom.mas_equalTo(-3);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(44);
        }];
        _searchBt = [UIButton buttonWithType:UIButtonTypeSystem];
        [_searchBt setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchBt addTarget:self action:@selector(searchBtClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_searchBt];
        [_searchBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_listBt);
            make.right.equalTo(_listBt.mas_left).offset(-5);
            make.width.mas_equalTo(0);      // 点击搜索条后弹出
        }];
        _searchBar = [[UISearchBar alloc]init];
        [self addSubview:_searchBar];
        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_searchBt);
            make.right.equalTo(_searchBt.mas_left).offset(-5);
            make.left.mas_equalTo(10);
        }];
        _searchBar.delegate = self;
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.placeholder = @"车牌号";
    }
    self.backgroundColor = [UIColor colorWithValue:0xf0f0f0 alpha:1.0];
    return self;
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    [_searchBar resignFirstResponder];
    return YES;
}

#pragma mark private
- (void)listBtClicked:(UIButton *)sender {
    [_delegate didSearchBarMenuClicked];
}

- (void)searchBtClicked:(UIButton *)sender {
    [_delegate  didSearchBarSearchClicked:_searchBar.text];
}

#pragma mark delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [_searchBt mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(44);
    }];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [_searchBt mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
    }];
}

@end
