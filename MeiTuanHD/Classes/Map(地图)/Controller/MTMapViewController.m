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

@interface MTMapViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
/**分类*/
@property (weak,nonatomic) UIBarButtonItem *categoryItem;

@property (nonatomic ,strong)CLLocationManager *manager;

/**为了再次打开区域下拉菜单时候的时候默认选中相应的区域*/
/** 当前选中的category*/
@property (nonatomic ,assign)NSInteger selectedCategoryIndex;
/** 当前选中的subcategory*/
@property (nonatomic ,assign)NSInteger selectedSubCategoryIndex;
/** 商户信息*/
@property (nonatomic ,strong)NSMutableArray *anntations;

@end

@implementation MTMapViewController
#pragma mark - 懒加载
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
    
    MTBusinessAnnotation *annotation =   [[MTBusinessAnnotation alloc]init];
    annotation.coordinate = CLLocationCoordinate2DMake(30.66, 104.001);
    annotation.title = @"这是提前加好的";
    annotation.subtitle = @"怎么就是显示不了呢";
    [self.mapView addAnnotation:annotation];
    // 设置代理
    self.mapView.delegate = self;
    
    [KNotificationCenter addObserver:self selector:@selector(updateCategoryItem:) name:kMTCategoryDidChangedNotification object:nil];
    
}
#pragma mark - 设置通知，监听分类下拉菜单的变化
- (void)dealloc
{
    [KNotificationCenter removeObserver:self name:kMTCategoryDidChangedNotification object:nil];
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
    MKCoordinateSpan span = MKCoordinateSpanMake(0.052996, 0.039880);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [mapView setRegion:region animated:YES];

    
}


/**
 * 用户地图的显示区域发生变化会调用该方法
 */
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    JWLog(@"区域发生了变化");
    
    
    // 2.反地理编码
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = mapView.userLocation.location;
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        // 如果有错误,或者解析出来的地址数量为0
        if (placemarks.count == 0 || error) return ;
        
        // 取出地标,就可以取出地址信息,以及CLLocation对象
        CLPlacemark *pm = [placemarks firstObject];
        
        //团购搜索需要城市，区域，经纬度，radius 等信息
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
#warning 注意:如果是取出城市的话,需要判断locality属性是否有值(直辖市时,该属性为空)
        NSString *city = nil;
        if (pm.locality) {
            city = pm.locality;
        } else {
            city = pm.administrativeArea;
        }
        
        CGFloat longitude = mapView.userLocation.location.coordinate.longitude;
        CGFloat latitude = mapView.userLocation.location.coordinate.latitude;
        
        city = [city substringToIndex:city.length-1];
        
        //构造参数，传给服务器
        params[@"city"] = city;
        params[@"region"] = pm.subLocality;
        params[@"longitude"] = @(longitude);
        params[@"latitude"] = @(latitude);
        params[@"radius"] = @5000;
        
        [[MTHttpTool sharedHttpTool] requestWithURL:@"v1/deal/find_deals" params:params success:^(id result) {
            
            NSArray *deals = [MTDeal mj_objectArrayWithKeyValuesArray:result[@"deals"]];
            for (MTDeal *deal in deals) {
                for (MTBusiness *business in deal.businesses) {
                    MTBusinessAnnotation *annotation = [[MTBusinessAnnotation alloc]init];
                    annotation.title = deal.title;
                    annotation.subtitle = deal.desc;
                    
                    annotation.coordinate = CLLocationCoordinate2DMake(business.longitude, business.latitude);
//                    if (![self.anntations containsObject:annotation]) {
//                        [self.anntations addObject:annotation];
//                    }
                    if (![self.mapView.annotations containsObject:annotation]) {
                        
                        [self.mapView addAnnotation:annotation];
                    }
                }
            }
            
            //移除就得annotation
            //            NSArray *annotations = self.mapView.annotations;
            //            [self.mapView removeAnnotations:annotations];
            
            //新增新的annotations
//            [self.mapView addAnnotations:self.anntations];
            
        } failure:^(NSError *error) {
            
            JWLog(@"请求失败 %@",error);
            
        }];
    }];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    return nil;
    JWLog(@"annotation :%@",annotation);
    if(![annotation isKindOfClass:[MTBusinessAnnotation class]])   return nil;
    
    static NSString *identfier = @"identifier";
    MKAnnotationView *annotationView  = [mapView dequeueReusableAnnotationViewWithIdentifier:identfier];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc]init];
        annotationView.canShowCallout = YES;
    }
    annotationView.annotation = annotation;
    return annotationView;
}
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views
{
    JWLog(@"");
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    JWLog(@"%@--%@",self.anntations,self.mapView.annotations);
}

@end
