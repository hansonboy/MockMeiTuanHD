
//
//  MTSearchCollectionViewController.m
//  MTHD
//
//  Created by wangjianwei on 16/4/13.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTSearchCollectionViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MJRefresh.h"

@interface MTSearchCollectionViewController ()<UISearchBarDelegate>
/** 搜索的关键词*/
@property (nonatomic ,copy)NSString *keyword;
@end

@implementation MTSearchCollectionViewController
#pragma mark - 实现父类交给子类的方法
-(void)setupParams:(NSMutableDictionary *)params
{
    if (self.keyword) {
        params[@"keyword"] = self.keyword;
        params[@"city"] = self.city ? self.city : @"北京";
    }
   
}
#pragma mark - 初始化
- (void)setKeyword:(NSString *)keyword {
    _keyword = keyword;
    [self.collectionView.mj_header beginRefreshing];
}
- (void)viewDidLoad {

    
    [super viewDidLoad];
    //设置左边的item
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(goBack) imageName:@"icon_back" selecteImageName:@"icon_back_highlighted"];
    //设置标题item
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.placeholder = @"请输入关键字";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
}
#pragma mark - action
- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - searchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    JWLog(@"%@",searchBar.text);
    self.keyword = searchBar.text;
    [searchBar resignFirstResponder];
}
@end
