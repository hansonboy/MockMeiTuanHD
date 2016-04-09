//
//  MTHomeController.m
//  MeiTuanHD
//
//  Created by wangjianwei on 16/3/28.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTHomeController.h"
#import "UIBarButtonItem+Extension.h"
#import "MTHomeTopItem.h"
#import "UIView+Extension.h"
#import "MTCatogeryViewController.h"
#import "MTRegionViewController.h"
#import "MTSortViewController.h"
#import "MTNavigationController.h"
@interface MTHomeController()
/**
 *  分类
 */
@property (weak,nonatomic) UIBarButtonItem *categoryItem;
/**
 *  城市
 */
@property (weak,nonatomic) UIBarButtonItem *cityItem;
/**
 *  排序
 */
@property (weak,nonatomic) UIBarButtonItem *sortItem;

@end
@implementation MTHomeController
#pragma mark -初始化
-(instancetype)init{
    if (self = [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]]) {
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    return  self;
}

#pragma mark - 设置导航栏内容
-(void)viewDidLoad{
    //设置导航栏内容
    [self setupRightBarBtnItem];
    [self setupLeftBarBtnItem];
}
-(void)setupLeftBarBtnItem{
    //1.logo
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc]initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"]]];
    
    //2.类别
    MTHomeTopItem * category = [[MTHomeTopItem alloc]init];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc]initWithCustomView:category];
    [category addTarget:self action:@selector(changeCategory)];
    self.categoryItem = categoryItem;
    
    //3.地区
    MTHomeTopItem * city = [[MTHomeTopItem alloc]init];
    [city addTarget:self action:@selector(changeCity)];
    UIBarButtonItem *cityItem = [[UIBarButtonItem alloc]initWithCustomView:city];
    self.cityItem = cityItem;
   
    //4.排序
    MTHomeTopItem * sort = [[MTHomeTopItem alloc]init];
     [sort addTarget:self action:@selector(sort)];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc]initWithCustomView:sort];
    self.sortItem = sortItem;
    
    self.navigationItem.leftBarButtonItems = @[logoItem,categoryItem,cityItem,sortItem];
}


-(void)setupRightBarBtnItem{

    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithTarget:self action:@selector(search:) imageName:@"icon_search" selecteImageName:@"icon_search_highlighted"];
    searchItem.customView.width  =  60;
    
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithTarget:self action:@selector(location:) imageName:@"icon_map" selecteImageName:@"icon_map_highlighted"];
    mapItem.customView.width = 60;
    
    self.navigationItem.rightBarButtonItems = @[mapItem,searchItem];
}
#pragma mark - 响应导航栏方法
-(void)search:(id)sender{
    JWLog(@"");
}
-(void)location:(id)sender{
      JWLog(@"");
}
-(void)sort{

    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    JWLog(@"");
    MTSortViewController *sortVC =  [[UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MTSortViewController"];
    sortVC.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:sortVC animated:YES completion:nil];
}
-(void)changeCategory{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    JWLog(@"");
    MTCatogeryViewController *setCatogeryVC = [[MTCatogeryViewController alloc]init];
    UIPopoverController *popoverController = [[UIPopoverController alloc]initWithContentViewController:setCatogeryVC];
    [popoverController presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
-(void)changeCity{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    JWLog(@"");
    MTRegionViewController *changeCityVC = [[MTRegionViewController alloc]init];
    UIPopoverController *popoverController = [[UIPopoverController alloc]initWithContentViewController:changeCityVC];
    [popoverController presentPopoverFromBarButtonItem:self.cityItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
@end
