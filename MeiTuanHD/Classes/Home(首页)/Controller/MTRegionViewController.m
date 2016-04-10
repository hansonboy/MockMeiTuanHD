//
//  MTChangeCityViewController.m
//  MeiTuanHD
//
//  Created by wangjianwei on 16/3/30.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTRegionViewController.h"
#import "MTDropDownView.h"
#import "MTChangeCityViewController.h"
#import "MTNavigationController.h"
#import "MJExtension.h"
#import "MTCity.h"
#import "MTRegion.h"
#import "Masonry.h"
@interface MTRegionViewController ()<MTDropDownViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *topChangeCityView;
@property (nonatomic ,weak) MTDropDownView *dropDownView;
@property (nonatomic ,strong)NSArray *cities;
@property (nonatomic ,strong)NSArray *regions;

@end

@implementation MTRegionViewController
-(NSArray *)regions
{
    if(_regions == nil)
    {
        _regions = [self.cities[141] regions];
    }
    return _regions;
}
-(NSArray *)cities
{
    if( _cities == nil)
    {
        [MTCity setupObjectClassInArray:^NSDictionary *{
            return @{@"regions":@"MTRegion"};
        }];
        _cities = [MTCity mj_objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}
- (IBAction)changeCity {
    MTChangeCityViewController *changeCity = [[MTChangeCityViewController alloc]init];
    MTNavigationController *navi = [[MTNavigationController alloc]initWithRootViewController:changeCity];
    navi.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navi animated:YES completion:nil];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    MTDropDownView *dropView = [MTDropDownView dropDownView];
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
