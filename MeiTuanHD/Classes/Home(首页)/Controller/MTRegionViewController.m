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
@interface MTRegionViewController ()
@property (weak,nonatomic) MTDropDownView *dropDownView;
@end

@implementation MTRegionViewController
- (IBAction)changeCity {
    MTChangeCityViewController *changeCity = [[MTChangeCityViewController alloc]init];
    MTNavigationController *navi = [[MTNavigationController alloc]initWithRootViewController:changeCity];
    navi.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navi animated:YES completion:nil];
}

//#pragma mark 测试下生命周期
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
