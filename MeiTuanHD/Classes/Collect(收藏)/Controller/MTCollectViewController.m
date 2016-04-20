//
//  MTCollectViewController.m
//  MTHD
//
//  Created by wangjianwei on 16/4/21.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTCollectViewController.h"
#import "MTCollectDealTool.h"
#import "UIView+Extension.h"
#import "UIBarButtonItem+Extension.h"
@interface MTCollectViewController ()

@end

@implementation MTCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupNavigationBar];
    [self.deals addObjectsFromArray:[MTCollectDealTool allDeals]];
    [self.collectionView reloadData];
}
#pragma mark - 设置Item
//TODO: 设置导航栏响应事件
-(void)setupNavigationBar{
    UIBarButtonItem *back = [UIBarButtonItem itemWithTarget:self action:@selector(goBack) imageName:@"icon_back" selecteImageName:@"icon_back_highlighted"];


    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    UIBarButtonItem *allSelectItem = [[UIBarButtonItem alloc]initWithTitle:@"全选" style:UIBarButtonItemStyleDone target:self action:@selector(selectAll)];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(delete)];
    self.navigationItem.rightBarButtonItem = rightItem;

    self.title = @"我的收藏";
    self.navigationItem.leftBarButtonItems = @[back,allSelectItem,deleteItem];
}
- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)done {
    
}
- (void)selectAll
{

}
- (void)delete
{
    
}

@end
