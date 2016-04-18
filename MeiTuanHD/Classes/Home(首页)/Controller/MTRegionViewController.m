//
//  MTChangeCityViewController.m
//  MeiTuanHD
//
//  Created by wangjianwei on 16/3/30.
//  Copyright © 2016年 JW. All rights reserved.
//  显示下拉菜单中的当前的区域选择

#import "MTRegionViewController.h"
#import "MTDropDownView.h"
#import "MTChangeCityViewController.h"
#import "MTNavigationController.h"
#import "MJExtension.h"
#import "MTCity.h"
#import "MTRegion.h"
#import "Masonry.h"
#import "MTMetaTool.h"
@interface MTRegionViewController ()<MTDropDownViewDataSource,MTDropDownViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topChangeCityView;
@property (nonatomic ,weak) MTDropDownView *dropDownView;

@property (nonatomic ,strong)NSArray *regions;


@end
NSString *const kMTCityWillChangeNotification = @"kMTRegionWillChangeNotification";
NSString *const kMTRegionDidChangedNotification = @"kMTRegionDidChangedNotification";
NSString *const kMTRegionSelectedCityIndexUserInfoKey = @"kMTRegionSelectedCityIndexUserInfoKey";
NSString *const kMTRegionSelectedRegionIndexUserInfoKey = @"kMTRegionSelectedRegionIndexUserInfoKey";
NSString *const kMTRegionSelectedSubRegionIndexUserInfoKey = @"kMTRegionSelectedSubRegionIndexUserInfoKey";
@implementation MTRegionViewController
#pragma mark - 初始化
-(void)setSelectedCityIndex:(NSInteger)selectedCityIndex
{
    _selectedCityIndex = selectedCityIndex;
    self.dropDownView.dataSource = self;
}

-(NSArray *)regions
{
    _regions = [MTMetaTool cityByIndex:self.selectedCityIndex].regions;
    return _regions;
}

- (IBAction)changeCity {
    [KNotificationCenter postNotificationName:kMTCityWillChangeNotification object:self];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addNotificationForCityChanged];
    [self setupDropDownView];
}
#pragma mark - add Notification
-(void)addNotificationForCityChanged
{
     [KNotificationCenter addObserver:self selector:@selector(updateCityIndex:) name:kMTCityDidChangedNotification object:nil];
}
-(void)updateCityIndex:(NSNotification *)noti
{
    NSInteger cityIndex =  [noti.userInfo[kMTCityIndexUserInfoKey] integerValue];
    //通过在selelctedCityIndex 设置方法中重新设置dataSource 然后强制刷新所有的tableView
    self.selectedCityIndex = cityIndex;
    
    //当前的下拉菜单显示进行消失
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc
{
    [KNotificationCenter removeObserver:self name:kMTCityDidChangedNotification object:nil];
}
#pragma mark - setup dropDownView
-(void)setupDropDownView
{
    MTDropDownView *dropView = [MTDropDownView dropDownView];
    dropView.delegate = self;
    [self.view  addSubview:dropView];
    //为dropView添加约束
    [dropView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.topChangeCityView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    self.dropDownView = dropView;
    dropView.dataSource = self;
    self.preferredContentSize = CGSizeMake(self.dropDownView.frame.size.width, CGRectGetMaxY(self.dropDownView.frame)+10);
}
// 添加dropDownView 到区域下拉菜单
#pragma mark - MTDropDownViewDataSource
/** 主表中行的数量*/
-(NSInteger)numberOfRowsInMasterTable:(MTDropDownView *)dropDownView
{
    return self.regions.count;
}
/** 从表中行的数量*/
-(NSInteger)numberOfRowsInDetailTable:(MTDropDownView *)dropDownView inMasterRow:(NSInteger)masterRow
{
    MTRegion *region = self.regions[masterRow];
    return region.subregions.count;
}
/** 主表中行的标题*/
-(NSString *)dropDownView:(MTDropDownView *)dropDownView titleForRowAtMasterTable:(NSInteger)row
{
    return [[self.regions objectAtIndex:row] name];
}
/** 从表中行的标题*/
-(NSString *)dropDownView:(MTDropDownView *)dropDownView titleForRowAtDetailTable:(NSInteger)row inMasterRow:(NSInteger)masterRow
{
    MTRegion *region = self.regions[masterRow];
    return [region.subregions objectAtIndex:row];
}


/** 主表中行的accessoryType*/
-(UITableViewCellAccessoryType)dropDownView:(MTDropDownView *)dropDownView cellAccessoryTypeForRowAtMasterTable:(NSInteger)row
{
    MTRegion *region = self.regions[row];
    if (region.subregions.count == 0) {
        return UITableViewCellAccessoryNone;
    }else
        return UITableViewCellAccessoryDisclosureIndicator;
}
#pragma mark - dropDownView delegate
-(void)dropDownView:(MTDropDownView *)dropDownView didSelectRowAtMasterTable:(NSInteger)masterRow detailTableAtRow:(NSInteger)detailRow
{
  
    MTRegion *region = [self.regions objectAtIndex:masterRow];
    if (detailRow == -1) {//处理主表选定
        if (region.subregions.count == 0) {
            [KNotificationCenter postNotificationName:kMTRegionDidChangedNotification object:self userInfo:@{kMTRegionSelectedCityIndexUserInfoKey:@(self.selectedCityIndex),kMTRegionSelectedRegionIndexUserInfoKey:@(masterRow),kMTRegionSelectedSubRegionIndexUserInfoKey:@(0)}];
        }
    }
    else
    {
        [KNotificationCenter postNotificationName:kMTRegionDidChangedNotification object:self userInfo:@{kMTRegionSelectedCityIndexUserInfoKey:@(self.selectedCityIndex),kMTRegionSelectedRegionIndexUserInfoKey:@(masterRow),kMTRegionSelectedSubRegionIndexUserInfoKey:@(detailRow)}];
    }
    
}
#pragma mark 测试下生命周期
//-(instancetype)init{
//    if (self == [super init]) {
//        JWLog(@"");
//    }
//    return self;
//}
//-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
//    if (self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        JWLog(@"");
//    }
//    return self;
//}
//-(void)awakeFromNib{
//    [super awakeFromNib];
//    JWLog(@"");
//}
//-(instancetype)initWithCoder:(NSCoder *)aDecoder{
//    if (self == [super initWithCoder:aDecoder]) {
//        JWLog(@"");
//    }
//    return self;
//}
////常用来手动添加view，重写该方法，同时又是有xib 生成view ，很容易造成错误
//-(void)loadView{
//    [super loadView];
//    JWLog(@"");
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    JWLog(@"");
//}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    JWLog(@"");
//}
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    JWLog(@"");
//}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    JWLog(@"");
//}
//
//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    JWLog(@"");
//}
//-(void)viewWillLayoutSubviews{
//    [super viewWillLayoutSubviews];
//    JWLog(@"");
//}
//-(void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    JWLog(@"");
//}
@end
