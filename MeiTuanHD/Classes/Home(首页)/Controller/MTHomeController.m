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
@interface MTHomeController()

@end
@implementation MTHomeController
-(instancetype)init{
    if (self = [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]]) {
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    return  self;
}

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
    
    //3.地区
    MTHomeTopItem * city = [[MTHomeTopItem alloc]init];
    [city addTarget:self action:@selector(changeCity)];
    UIBarButtonItem *cityItem = [[UIBarButtonItem alloc]initWithCustomView:city];
   
    //4.排序
    MTHomeTopItem * sort = [[MTHomeTopItem alloc]init];
     [sort addTarget:self action:@selector(sort)];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc]initWithCustomView:sort];
    
    self.navigationItem.leftBarButtonItems = @[logoItem,categoryItem,cityItem,sortItem];
}
-(void)sort{
    JWLog(@"");
}
-(void)changeCategory{
    JWLog(@"");
    
}
-(void)changeCity{
    JWLog(@"");
}
-(void)setupRightBarBtnItem{

    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithTarget:self action:@selector(search:) imageName:@"icon_search" selecteImageName:@"icon_search_highlighted"];
    searchItem.customView.width  =  60;
    
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithTarget:self action:@selector(location:) imageName:@"icon_map" selecteImageName:@"icon_map_highlighted"];
    mapItem.customView.width = 60;
    
    self.navigationItem.rightBarButtonItems = @[mapItem,searchItem];
}
-(void)search:(id)sender{
    JWLog(@"");
}
-(void)location:(id)sender{
      JWLog(@"");
}
@end
