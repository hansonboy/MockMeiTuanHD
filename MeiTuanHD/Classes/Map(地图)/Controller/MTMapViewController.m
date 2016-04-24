//
//  MTMapViewController.m
//  MTHD
//
//  Created by wangjianwei on 16/4/22.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTMapViewController.h"
#import <MapKit/MapKit.h>
#import "UIBarButtonItem+Extension.h"
#import "MTHomeTopItem.h"
#import "MTCatogeryViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MTCategory.h"
#import "MTMetaTool.h"
#import "MTHttpTool.h"
#import "MTBusiness.h"
#import "MJExtension.h"
#import "MTDeal.h"
#import "MTBusinessAnnotation.h"
#import "MTMetaTool.h"
#import "DPAPI.h"
@interface MTMapViewController ()<MKMapViewDelegate,DPRequestDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
/**分类*/
@property (weak,nonatomic) UIBarButtonItem *categoryItem;

@property (nonatomic ,strong)CLLocationManager *manager;

@property (nonatomic, strong)CLGeocoder *geocoder;

/**为了再次打开区域下拉菜单时候的时候默认选中相应的区域*/
/** 当前选中的category*/
@property (nonatomic ,assign)NSInteger selectedCategoryIndex;
/** 当前选中的subcategory*/
@property (nonatomic ,assign)NSInteger selectedSubCategoryIndex;
/** 商户信息*/
@property (nonatomic ,strong)NSMutableArray *anntations;
/** 用来保存当前的城市*/
@property (nonatomic, copy)NSString *city;
/** 点评*/
@property (nonatomic ,strong)DPAPI *dp;
/** 保存上一次的请求,用来保证每次的请求结果不会混合*/
@property (nonatomic ,strong)DPRequest *lastRequest;

@property (nonatomic, assign)MKCoordinateRegion currentRegion;
@end

@implementation MTMapViewController
- (IBAction)backToCurrentLocation:(id)sender {
    [self.mapView setRegion:self.currentRegion animated:YES];
}

#pragma mark - 懒加载
- (DPAPI *)dp{
    if (_dp == nil) {
        _dp = [[DPAPI alloc]init];
    }
    return _dp;
}

- (CLGeocoder *)geocoder {
    if ( _geocoder == nil) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return  _geocoder;
}

- (CLLocationManager *)manager {
    if (_manager == nil) {
        _manager = [[CLLocationManager alloc]init];
    }
    return _manager;
}
- (NSMutableArray *)anntations {
    if (_anntations == nil) {
        _anntations = [[NSMutableArray alloc]init];
    }
    return _anntations;
}



#pragma mark - 设置通知，监听分类下拉菜单的变化
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     [KNotificationCenter addObserver:self selector:@selector(updateCategoryItem:) name:kMTCategoryDidChangedNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
      [KNotificationCenter removeObserver:self name:kMTCategoryDidChangedNotification object:nil];
}


- (void)updateCategoryItem:(NSNotification *)notification
{
    
    MTHomeTopItem *item = (MTHomeTopItem *)self.categoryItem.customView;
    NSInteger masterIndex = [notification.userInfo[kMTCategoryCategoryIndexUserInfoKey] integerValue];
    
#warning 有时候直接保存category 本身也许不失为是一个好办法，有时候并没有增大内存的开销，因为是强引用，不会产生额外的内存的开销，但是使用对象内部的字段是会产生内存开销的
    MTCategory *category = [MTMetaTool categoryByIndex:masterIndex];
    NSInteger index = [notification.userInfo[kMTCategorySubcategoiesIndexUserInfoKey] integerValue];
    
    [item setImage:category.small_icon highImage:category.small_highlighted_icon];
    NSString *detailTitle = index == 0?category.name:category.subcategories[index];
    [item setDetailTitle:detailTitle];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    self.selectedCategoryIndex = masterIndex;
    self.selectedSubCategoryIndex = index;
    
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self mapView:self.mapView regionDidChangeAnimated:YES];
    
}


#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupLeftBarButtonItem];
    
    // iOS8请求用户授权
    if ([self.manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.manager requestAlwaysAuthorization];
    }
    
    // 设置用户跟踪模式
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsCompass = YES;

    
}


#pragma mark - 设置顶部导航栏按钮
- (void)setupLeftBarButtonItem
{
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithTarget:self action:@selector(goBack) imageName:@"icon_back" selecteImageName:@"icon_back_highlighted"];
    //类别
    MTHomeTopItem * category = [[MTHomeTopItem alloc]init];
    [category setTitle:@"美团"];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc]initWithCustomView:category];
    [category addTarget:self action:@selector(changeCategory)];
    self.categoryItem = categoryItem;
    
    self.title = @"地图搜索";
    self.navigationItem.leftBarButtonItems = @[backItem,categoryItem];
}

#pragma mark - 响应导航栏Item方法
- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)changeCategory{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    
    MTCatogeryViewController *setCatogeryVC = [[MTCatogeryViewController alloc]init];
    UIPopoverController *popoverController = [[UIPopoverController alloc]initWithContentViewController:setCatogeryVC];
    [popoverController presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - MKMapView Delegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    JWLog(@"定位发生了变化");
    
    // 设置显示用户的位置和经纬度
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [mapView setRegion:region animated:YES];
    
    self.currentRegion = region;
    
    // 2.反地理编码
    [self.geocoder reverseGeocodeLocation:mapView.userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        // 如果有错误,或者解析出来的地址数量为0
        if (placemarks.count == 0 || error) return ;
        
        // 取出地标,就可以取出地址信息,以及CLLocation对象
        CLPlacemark *pm = [placemarks firstObject];
        
        NSString *city = pm.locality?pm.locality:pm.administrativeArea;
#warning 使用翻墙代理的时候，这个地方是不一样的，使用美国代理，返回的名称中不含市，使用中国的网络，市名称中包含有市，注意哦，要求传给服务器的城市名字中不含有‘市’
        self.city = [city substringToIndex:city.length-1];
        
        [self mapView:mapView regionDidChangeAnimated:YES];
        
    }];
    
}

/**
 * 用户地图的显示区域发生变化会调用该方法
 */
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if(self.city == nil)return;
    JWLog(@"区域发生了变化");
    //团购搜索需要城市，区域，经纬度，radius 等信息
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //构造参数，传给服务器
    NSString *category = nil;
    self.selectedSubCategoryIndex?[MTMetaTool subCategoryByMasterIndex:self.selectedCategoryIndex detailIndex:self.selectedSubCategoryIndex]:[[MTMetaTool categoryByIndex:self.selectedCategoryIndex] name];
    if (self.selectedSubCategoryIndex != 0) {
        category = [MTMetaTool subCategoryByMasterIndex:self.selectedCategoryIndex detailIndex:self.selectedSubCategoryIndex];
    }
    else{
        if (self.selectedCategoryIndex != 0) {
            category = [[MTMetaTool categoryByIndex:self.selectedCategoryIndex] name];
        }
    }
    if(category!= nil) params[@"category"] = category;
    
    params[@"city"] = self.city;
    params[@"longitude"] = @(mapView.region.center.longitude);
    params[@"latitude"] = @(mapView.region.center.latitude);
    params[@"radius"] = @(5000);
//    self.lastRequest = [self.dp requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    [self requestNewDealsWithParams:params];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MTBusinessAnnotation *)annotation
{
    //返回默认的大头针
    if(![annotation isMemberOfClass:[MTBusinessAnnotation class]])   return nil;
    
    //返回我们自己定义的大头针图像
    static NSString *identfier = @"identifier";
    MKAnnotationView *annotationView  = [mapView dequeueReusableAnnotationViewWithIdentifier:identfier];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc]initWithAnnotation:nil reuseIdentifier:identfier];
        annotationView.canShowCallout = YES;
    }
    
    //设置模型（位置、标题、子标题）
    annotationView.annotation = annotation;

    //设置图片
    annotationView.image = [UIImage imageNamed:annotation.icon]?[UIImage imageNamed:annotation.icon]:[UIImage imageNamed:@"ic_category_default"];

    return annotationView;
}

#pragma mark - 触摸测试
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    JWLog(@"%@--%@",self.anntations,self.mapView.annotations);
    
}
#pragma mark - 请求数据
- (void)requestNewDealsWithParams:(NSMutableDictionary *)params
{
    //    以下是使用的HTTPTool 请求我们的返回结果
//    [[MTHttpTool sharedHttpTool] requestWithURL:@"v1/deal/find_deals" params:params success:^(id result) {
//        JWLog(@"收到成功回调");
//        NSArray *deals = [MTDeal mj_objectArrayWithKeyValuesArray:result[@"deals"]];
//        for (MTDeal *deal in deals) {
//            for (MTBusiness *business in deal.businesses) {
//                
//                MTBusinessAnnotation *annotation = [[MTBusinessAnnotation alloc]init];
//                annotation.title = deal.title;
//                annotation.subtitle = deal.desc;
//                annotation.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
//                MTCategory *category = [MTMetaTool categoryByName:deal.categories.firstObject];
//                annotation.icon = category.map_icon;
//                
//                if ([self.mapView.annotations containsObject:annotation]) {
//                    break;
//                }else{
//                    [self.mapView addAnnotation:annotation];
//                }
//                
//            }
//        }
//        
//    } failure:^(NSError *error) {
//        
//        JWLog(@"请求失败 %@",error);
//        
//    }];
//    使用大众点评原来的API来请求数据
   self.lastRequest = [self.dp requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}
#pragma mark - DP request delegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if(self.lastRequest != request) return;
    JWLog(@"request 成功收到回调");
    NSArray *deals = [MTDeal mj_objectArrayWithKeyValuesArray:result[@"deals"]];
    MTCategory*category;
    for (MTDeal *deal in deals) {
        //获取团购所属类型
        category = [MTMetaTool categoryByName:deal.categories.lastObject];
        
        for (MTBusiness *business in deal.businesses) {
            MTBusinessAnnotation *annotation = [[MTBusinessAnnotation alloc]init];
            annotation.title = business.name;
            annotation.subtitle = deal.desc;
            
#warning            //我找到问题在哪里了：原因是我的longitude 和latitude 放的位置给放反了，很愚蠢的错误，找了3天才找到，中间试了很多其他的方法，学会了单元测试，学会了block封装回调
            annotation.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
            annotation.icon = category.map_icon;
            
            if ([self.mapView.annotations containsObject:annotation]) {
                break;
            }else{
                [self.mapView addAnnotation:annotation];
            }
            
        }
    }
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (self.lastRequest != request) {
        return;
    }else{
        JWLog(@"%@",request.params);
        JWLog(@"请求失败：%@",error);
    }
}
@end
