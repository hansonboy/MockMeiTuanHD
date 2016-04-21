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


#import "MJExtension.h"
#import "MJRefresh.h"
#import "MTSearchCollectionViewController.h"
#import "AwesomeMenu.h"
#import "Masonry.h"
#import "MTCollectViewController.h"
#import "MTCollectDealTool.h"

@interface MTHomeController()<AwesomeMenuDelegate>
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

static NSString *const kMTUserDefaultsCityKey = @"kMTUserDefaultsRegionKey";

@implementation MTHomeController
@synthesize selectedCityIndex = _selectedCityIndex;
#pragma mark - 恢复本地保存的字段
- (NSInteger)selectedCityIndex
{
    _selectedCityIndex = [kMTUserDefaults integerForKey:kMTUserDefaultsCityKey];
    return _selectedCityIndex;
}

-(void)setSelectedCityIndex:(NSInteger)selectedCityIndex
{
    _selectedCityIndex = selectedCityIndex;
    [kMTUserDefaults setInteger:_selectedCityIndex forKey:kMTUserDefaultsCityKey];
    [kMTUserDefaults synchronize];
}
#pragma mark - 开始启动时候加载数据
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //检查是否有选中的城市，如果没有提醒进行选择
    if(self.selectedCityIndex == 0)
    {
        //显示改变城市的控制器
        //TODO: object 必须为nil，因为我调用的方法会将object dismiss掉
        [KNotificationCenter postNotificationName:kMTCityWillChangeNotification object:nil];
    }
    else
    {
        [KNotificationCenter postNotificationName:kMTCityDidChangedNotification object:nil userInfo:@{kMTCityIndexUserInfoKey:@(self.selectedCityIndex)}];
        [self.collectionView.mj_header beginRefreshing];
    }
}
#pragma mark - 实现父类交给子类的方法
-(void)setupParams:(NSMutableDictionary *)params
{
    //添加分类条件
    if (self.selectedCategoryIndex != 0) {
        
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

}

#pragma mark - 设置导航栏内容
-(void)viewDidLoad{
    //设置导航栏内容
    [self setupRightBarBtnItem];
    [self setupLeftBarBtnItem];
    [self addNotification];
    
    //设置默认的选中的排序类别
     self.selectedSortIndex = 1;
//    //设置默认的选中的城市
    //初始化为-1，防止每次都从本地读取文件
    [self setupAwesomeMenu];
    
}

-(void)setupLeftBarBtnItem{
    //1.logo
    UIBarButtonItem * logoItem = [[UIBarButtonItem alloc]initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"]]];
    //2.类别
    MTHomeTopItem * category = [[MTHomeTopItem alloc]init];
    [category setTitle:@"美团"];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc]initWithCustomView:category];
    [category addTarget:self action:@selector(changeCategory)];      self.categoryItem = categoryItem;
    
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
    
    [KNotificationCenter addObserver:self selector:@selector(dismissRegionDropDown:) name:kMTCityWillChangeNotification object:nil];
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
    if (notification.name == kMTCityDidChangedNotification) {
        self.selectedCityIndex = [notification.userInfo[kMTCityIndexUserInfoKey] integerValue];
        
    }
    else
    {
        self.selectedCityIndex = [notification.userInfo[kMTRegionSelectedCityIndexUserInfoKey] integerValue];
        self.selectedRegionIndex = [notification.userInfo[kMTRegionSelectedRegionIndexUserInfoKey] integerValue];
        self.selectedSubregionIndex = [notification.userInfo[kMTRegionSelectedSubRegionIndexUserInfoKey] integerValue];
    }
    MTCity *city = [MTMetaTool cityByIndex:self.selectedCityIndex];
    MTRegion *region = [city.regions objectAtIndex:self.selectedRegionIndex];
    
    NSString *title = [NSString stringWithFormat:@"%@-%@",city.name,region.name];
    [item setTitle:title];
    NSString *detailTitle = self.selectedSubregionIndex == 0?region.name:[region.subregions objectAtIndex:self.selectedSubregionIndex];
    [item setDetailTitle:detailTitle];
    
    
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

//点击区域下拉菜单的改变城市后，区域下拉菜单消失，然后modal具体的改变城市的controller
- (void)dismissRegionDropDown:(NSNotification *)noti
{
    MTRegionViewController * region = noti.object;
    [region dismissViewControllerAnimated:YES completion:nil];
    
    //显示改变城市的controller
    MTChangeCityViewController *changeCity = [[MTChangeCityViewController alloc]init];
    MTNavigationController *navi = [[MTNavigationController alloc]initWithRootViewController:changeCity];
    navi.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navi animated:YES completion:nil];
    
}
-(void)dealloc
{
    [KNotificationCenter removeObserver:self name:kMTCategoryDidChangedNotification object:nil];
    [KNotificationCenter removeObserver:self name:kMTRegionDidChangedNotification object:nil];
    [KNotificationCenter removeObserver:self name:kMTCityDidChangedNotification object:nil];
    [KNotificationCenter removeObserver:self name:kMTSortViewControllerDidNewSortNotification object:nil];
    [KNotificationCenter removeObserver:self name:kMTCityWillChangeNotification object:nil];
}
#pragma mark - 响应导航栏方法
-(void)search:(id)sender{
  
     MTSearchCollectionViewController *searchCVC = [[MTSearchCollectionViewController alloc]init];
    
    searchCVC.city = [MTMetaTool cityByIndex:self.selectedCityIndex].name;
    
    MTNavigationController *navi = [[MTNavigationController alloc]initWithRootViewController:searchCVC];
      [self presentViewController:navi animated:YES completion:nil];
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
    //将其他的popover隐藏
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    
    //显示新的popover
    MTRegionViewController *changeCityVC = [[MTRegionViewController alloc]init];
    changeCityVC.selectedCityIndex = self.selectedCityIndex;
    changeCityVC.selectedRegionIndex = self.selectedRegionIndex;
    changeCityVC.selectedSubregionIndex = self.selectedSubregionIndex;
    UIPopoverController *popoverController = [[UIPopoverController alloc]initWithContentViewController:changeCityVC];
    [popoverController presentPopoverFromBarButtonItem:self.cityItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
#pragma mark - setup awesomeMenu
-(void)setupAwesomeMenu
{
    AwesomeMenuItem *collectItem = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    AwesomeMenuItem *scanItem = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_highlighted"]];
    AwesomeMenuItem *moreItem = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_more_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_more_highlighted"]];
    AwesomeMenuItem *otherItem = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_more_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_more_highlighted"]];
    
    //开始按钮
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_normal"] highlightedImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"] ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"]];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc]initWithFrame:CGRectZero startItem:startItem optionMenus:@[collectItem,scanItem,moreItem,otherItem]];
    menu.menuWholeAngle = M_PI/2;
    [self.view addSubview:menu];
    
    [menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    menu.rotateAddButton = NO;
    menu.startPoint = CGPointMake(50,50);
    menu.delegate = self;
}

#pragma mark - awesomeMenu delegate
-(void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
     switch (idx) {
        case 0:{//收藏

            menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
            MTCollectViewController *collect = [[MTCollectViewController alloc]init];
            MTNavigationController *navi = [[MTNavigationController alloc]initWithRootViewController:collect];
            [self presentViewController:navi animated:YES completion:nil];
            
         break;
        }
          
        case 1:{//最近
            //TODO: 最近浏览
            menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
            break;
        }
        default:
            break;
    }
}
-(void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu
{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
}
-(void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu
{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];

}

@end
