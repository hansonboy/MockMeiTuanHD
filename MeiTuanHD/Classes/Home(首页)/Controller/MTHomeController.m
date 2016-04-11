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
#import "MTSortViewController.h"
#import "MTRegionViewController.h"
#import "MTNavigationController.h"
#import "MTCategory.h"
#import "MTMetaTool.h"
#import "MTRegion.h"
#import "MTCity.h"
#import "MTSort.h"
#import "MTChangeCityViewController.h"
#import "DPAPI.h"
@interface MTHomeController()<DPRequestDelegate>
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

/**为了再次打开区域下拉菜单时候的时候默认选中相应的区域*/
/** 当前选中的category*/
@property (nonatomic ,assign)NSInteger selectedCategoryIndex;
/** 当前选中的subcategory*/
@property (nonatomic ,assign)NSInteger selectedSubCategoryIndex;

/** 当前选中的城市*/
@property (nonatomic ,assign)NSInteger selectedCityIndex;
/** 当前选中的区域*/
@property (nonatomic ,assign)NSInteger selectedRegionIndex;
/** 当前选中的子区域*/
@property (nonatomic ,assign)NSInteger selectedSubregionIndex;

/** 当前选中的排序规则*/
@property (nonatomic ,assign)NSInteger selectedSortIndex;

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
    [self addNotification];
}

-(void)setupLeftBarBtnItem{
    //1.logo
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc]initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"]]];
    //2.类别
    MTHomeTopItem * category = [[MTHomeTopItem alloc]init];
    [category setTitle:@"美团"];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc]initWithCustomView:category];
    [category addTarget:self action:@selector(changeCategory)];
    self.categoryItem = categoryItem;
    
    //3.地区
    MTHomeTopItem * city = [[MTHomeTopItem alloc]init];
    [city setTitle:@"区域"];
    [city addTarget:self action:@selector(changeCity)];
    UIBarButtonItem *cityItem = [[UIBarButtonItem alloc]initWithCustomView:city];
    self.cityItem = cityItem;
   
    //4.排序
    MTHomeTopItem * sort = [[MTHomeTopItem alloc]init];
     [sort addTarget:self action:@selector(sort)];
    [sort setImage:@"icon_sort" highImage:@"icon_sort_highlighted"];
    [sort setTitle:@"排序"];
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
#pragma mark - add NSNotification
-(void)addNotification
{
    [KNotificationCenter addObserver:self selector:@selector(updateCategoryItem:) name:kMTCategoryDidChangedNotification object:nil];
    
    [KNotificationCenter addObserver:self selector:@selector(updateRegionItem:) name:kMTRegionDidChangedNotification object:nil];
    
    [KNotificationCenter addObserver:self selector:@selector(updateRegionItem:) name:kMTCityDidChangedNotification object:nil];
    
    [KNotificationCenter addObserver:self selector:@selector(updateSortItem:) name:kMTSortViewControllerDidNewSortNotification object:nil];
}

-(void)updateCategoryItem:(NSNotification *)notification
{
    
    MTHomeTopItem *item = (MTHomeTopItem *)self.categoryItem.customView;
    NSInteger masterIndex = [notification.userInfo[kMTCategoryCategoryIndexUserInfoKey] integerValue];
    MTCategory *category = [MTMetaTool categoryByIndex:masterIndex];
    NSInteger index = [notification.userInfo[kMTCategorySubcategoiesIndexUserInfoKey] integerValue];
    
    [item setImage:category.small_icon highImage:category.small_highlighted_icon];
    NSString *detailTitle = index == 0?category.name:category.subcategories[index];
    [item setDetailTitle:detailTitle];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    self.selectedCategoryIndex = masterIndex;
    self.selectedSubCategoryIndex = index;
    [self loadNewDeals];
}
-(void)updateRegionItem:(NSNotification *)notification
{
    
    MTHomeTopItem *item = (MTHomeTopItem *)self.cityItem.customView;
    NSInteger cityIndex = 0;
    NSInteger regionIndex = 0;
    NSInteger subRegionIndex = 0;
    if (notification.name == kMTCityDidChangedNotification) {
        cityIndex = [notification.userInfo[kMTCityIndexUserInfoKey] integerValue];
    }
    else
    {
        cityIndex = [notification.userInfo[kMTRegionSelectedCityIndexUserInfoKey] integerValue];
        regionIndex = [notification.userInfo[kMTRegionSelectedRegionIndexUserInfoKey] integerValue];
        subRegionIndex = [notification.userInfo[kMTRegionSelectedSubRegionIndexUserInfoKey] integerValue];
    }
    MTCity *city = [MTMetaTool cityByIndex:cityIndex];
    MTRegion *region = [city.regions objectAtIndex:regionIndex];
    
    NSString *title = [NSString stringWithFormat:@"%@-%@",city.name,region.name];
    [item setTitle:title];
    NSString *detailTitle = subRegionIndex == 0?region.name:[region.subregions objectAtIndex:subRegionIndex];
    [item setDetailTitle:detailTitle];
    self.selectedCityIndex = cityIndex;
    self.selectedRegionIndex = regionIndex;
    self.selectedSubregionIndex = subRegionIndex;
    
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    
    [self loadNewDeals];
}
-(void)updateSortItem:(NSNotification *)noti
{
    NSInteger index = [noti.userInfo[kMTSortNumberUserInfoKey] integerValue];
    MTHomeTopItem *item = (MTHomeTopItem *)self.sortItem.customView;
    MTSort *sort = [[MTMetaTool sorts]objectAtIndex:index];
    [item setDetailTitle:sort.label];
    [item setTitle:@"排序"];
    self.selectedSortIndex = sort.value.integerValue;
    [self loadNewDeals];
}
-(void)dealloc
{
    [KNotificationCenter removeObserver:self name:kMTCategoryDidChangedNotification object:nil];
    [KNotificationCenter removeObserver:self name:kMTRegionDidChangedNotification object:nil];
    [KNotificationCenter removeObserver:self name:kMTCityDidChangedNotification object:nil];
    [KNotificationCenter removeObserver:self name:kMTSortViewControllerDidNewSortNotification object:nil];
}
#pragma mark - 请求服务器的数据
/** 获取新的请求订单，API参考大众点评：http://developer.dianping.com/app/api/v1/deal/find_deals*/
- (void)loadNewDeals {
    DPAPI *dp = [[DPAPI alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //添加分类条件
    if (self.selectedCategoryIndex!=0) {
        
        MTCategory *category = [MTMetaTool categoryByIndex:self.selectedCategoryIndex];
        
        NSString *name = self.selectedSubCategoryIndex == 0 ?category.name:[category.subcategories objectAtIndex:self.selectedSubCategoryIndex];
        params[@"category"] = name;
    }
     //添加城市条件
    MTCity *city = [MTMetaTool cityByIndex:self.selectedCityIndex];
    params[@"city"] = city.name;
    //添加区域条件
    if(self.selectedRegionIndex)
    {
        MTRegion *region = [city.regions objectAtIndex:self.selectedRegionIndex];
        NSString *detailRegion = self.selectedSubregionIndex == 0?region.name:[region.subregions objectAtIndex:self.selectedSubregionIndex];
        if(detailRegion)
            params[@"region"] = detailRegion;
    }
    //排序规则
    params[@"sort"] = @(self.selectedSortIndex);
    //单页限制
    params[@"limit"] = @5;
    [dp requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    

    JWLog(@"%@",params);
}
#pragma mark - DP request delegate
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    JWLog(@"%@",error);
}
-(void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    JWLog(@"%@",result);
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

    MTSortViewController *sortVC = [[MTSortViewController alloc]init];;
    UIPopoverController *popoverVC = [[UIPopoverController alloc]initWithContentViewController:sortVC];
    [popoverVC presentPopoverFromBarButtonItem:self.sortItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
-(void)changeCategory{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
 
    MTCatogeryViewController *setCatogeryVC = [[MTCatogeryViewController alloc]init];
    UIPopoverController *popoverController = [[UIPopoverController alloc]initWithContentViewController:setCatogeryVC];
    [popoverController presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
-(void)changeCity{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
  
    MTRegionViewController *changeCityVC = [[MTRegionViewController alloc]init];
    changeCityVC.selectedCityIndex = self.selectedCityIndex;
    changeCityVC.selectedRegionIndex = self.selectedRegionIndex;
    changeCityVC.selectedSubregionIndex = self.selectedSubregionIndex;
    UIPopoverController *popoverController = [[UIPopoverController alloc]initWithContentViewController:changeCityVC];
    [popoverController presentPopoverFromBarButtonItem:self.cityItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

@end
