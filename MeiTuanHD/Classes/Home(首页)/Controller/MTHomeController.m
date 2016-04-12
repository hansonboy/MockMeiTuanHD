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
#import "MTDealCollectionViewCell.h"
#import "MTDeal.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
static const NSInteger countPerPage = 40;
static NSString *const identificer = @"MTDealCollectionViewCell";
@interface MTHomeController()<DPRequestDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
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
/** 当前的团购订单数组*/
@property (nonatomic ,strong)NSMutableArray *deals;
/** 当前页码*/
@property (nonatomic ,assign)NSInteger currentPage;
/** 总的订单数量*/
@property (nonatomic ,assign)NSInteger totalCount;
/** 最近的一次请求：出现多次请求冲突的时候，响应最近一次请求*/
@property (nonatomic ,strong)DPRequest  *recentRequest;
@end
@implementation MTHomeController
#pragma mark -初始化collectionView 及上拉刷新下拉刷新
-(instancetype)init{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(300, 300);
    if (self = [super initWithCollectionViewLayout:flowLayout]) {
        self.collectionView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"MTDealCollectionViewCell" bundle:[NSBundle mainBundle]]forCellWithReuseIdentifier:identificer];
        self.collectionView.alwaysBounceVertical = YES;
        
        
        self.collectionView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDeals)];
        self.collectionView.mj_footer =  [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
        self.collectionView.mj_footer.hidden = YES;
        }
    return  self;
}
- (NSMutableArray *)deals {
    if (_deals == nil) {
        _deals = [NSMutableArray array];
    }
    return _deals;
}
#pragma mark - 设置横竖屏下的间距
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    int columns = 2;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    if(size.width == 1024.0) //横屏状态
    {
        columns = 3;
    }
    CGFloat HM = (size.width - columns*flowLayout.itemSize.width)/(columns+1);
    flowLayout.minimumLineSpacing = HM;
    flowLayout.sectionInset = UIEdgeInsetsMake(HM, HM, HM, HM);
    self.collectionView.collectionViewLayout = flowLayout;
}
#pragma mark - 开始启动时候加载数据
-(void)viewWillAppear:(BOOL)animated
{
    [self.collectionView.mj_header beginRefreshing];
}
#pragma mark - 设置导航栏内容
-(void)viewDidLoad{
    //设置导航栏内容
    [self setupRightBarBtnItem];
    [self setupLeftBarBtnItem];
    [self addNotification];
    
    //设置默认的选中的排序类别
     self.selectedSortIndex = 1;
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
    [self.collectionView.mj_header beginRefreshing];
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
    
    [self.collectionView.mj_header beginRefreshing];
}
-(void)updateSortItem:(NSNotification *)noti
{
    NSInteger index = [noti.userInfo[kMTSortNumberUserInfoKey] integerValue];
    MTHomeTopItem *item = (MTHomeTopItem *)self.sortItem.customView;
    MTSort *sort = [[MTMetaTool sorts]objectAtIndex:index];
    [item setDetailTitle:sort.label];
    [item setTitle:@"排序"];
    self.selectedSortIndex = sort.value.integerValue;
    [self.collectionView.mj_header beginRefreshing];
}
-(void)dealloc
{
    [KNotificationCenter removeObserver:self name:kMTCategoryDidChangedNotification object:nil];
    [KNotificationCenter removeObserver:self name:kMTRegionDidChangedNotification object:nil];
    [KNotificationCenter removeObserver:self name:kMTCityDidChangedNotification object:nil];
    [KNotificationCenter removeObserver:self name:kMTSortViewControllerDidNewSortNotification object:nil];
}
#pragma mark - 请求服务器的数据
- (void)loadDeals
{
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
    params[@"limit"] = @(countPerPage);
    params[@"page"] = @(self.currentPage);
    self.recentRequest = [dp requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    JWLog(@"%@",params);

}
/** 获取新的请求订单，API参考大众点评：http://developer.dianping.com/app/api/v1/deal/find_deals*/
- (void)loadNewDeals {
    self.currentPage = 1;
    [self loadDeals];
}
- (void)loadMoreDeals
{
    self.currentPage ++;
    [self loadDeals];
}
#pragma mark - DP request delegate
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (error != nil) {
        JWLog(@"%@",error);
        [MBProgressHUD showError:@"网络出故障了，请您稍后再试" toView:self.view];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }
}
-(void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    //当不是最近的一次请求返回的时候，忽略该请求结果
    if(![self.recentRequest isEqual:request])return;
    if(self.currentPage == 1)
    {
        [self.collectionView.mj_header endRefreshing];
        [self.deals removeAllObjects];
        self.deals = [MTDeal mj_objectArrayWithKeyValuesArray:result[@"deals"]];
        //如果不能够一行全部返回的话，那么就显示上拉刷新功能
        self.collectionView.mj_footer.hidden = countPerPage*self.currentPage > [result[@"total_count"] integerValue];
    }
    else
    {
        [self.collectionView.mj_footer endRefreshing];
        //当前订单全部返回的时候，隐藏上拉刷新按钮
        if (countPerPage*self.currentPage >= [result[@"total_count"] integerValue]) {
            self.collectionView.mj_footer.hidden = YES;
        }
        [self.deals addObjectsFromArray:[MTDeal mj_objectArrayWithKeyValuesArray:result[@"deals"]]];
    }
    [self.collectionView reloadData];
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
#pragma mark -UICollectionViewController data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    JWLog(@"----");
    [self viewWillTransitionToSize:CGSizeMake(self.collectionView.size.width, 0) withTransitionCoordinator:nil];
    return self.deals.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    MTDealCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identificer forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MTDealCollectionViewCell alloc]init];
    }
    cell.deal = [self.deals objectAtIndex:indexPath.item];
    return cell;
}

@end
