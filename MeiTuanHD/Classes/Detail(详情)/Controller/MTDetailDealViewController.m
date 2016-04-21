
//
//  MTDetailDealViewController.m
//  MTHD
//
//  Created by wangjianwei on 16/4/13.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTDetailDealViewController.h"
#import "MTDeal.h"
#import "UIImageView+WebCache.h"
#import "DPAPI.h"
#import "MJExtension.h"
#import "MTRestriction.h"
#import "MTCollectDealTool.h"
#import "MBProgressHUD+MJ.h"
@interface MTDetailDealViewController ()<UIWebViewDelegate,DPRequestDelegate>
/**
 *  细节webview
 */
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;
/** 随时退款*/
@property (weak, nonatomic) IBOutlet UIButton *freetimeRefound;
/** 过期退款*/
@property (weak, nonatomic) IBOutlet UIButton *expiredRefound;
/** 还剩多长时间*/
@property (weak, nonatomic) IBOutlet UIButton *remainTime;
/** 已经售卖多少数量*/
@property (weak, nonatomic) IBOutlet UIButton *soldNumbers;
/** 立刻购买*/
@property (weak, nonatomic) IBOutlet UIButton *buyNow;
/** 收藏*/
@property (weak, nonatomic) IBOutlet UIButton *collect;
/** 分享*/
@property (weak, nonatomic) IBOutlet UIButton *share;

@property (weak, nonatomic) IBOutlet UIImageView *dealImg;
@property (weak, nonatomic) IBOutlet UILabel *dealTitle;
@property (weak, nonatomic) IBOutlet UILabel *dealDesc;

@property (nonatomic ,strong)MTDeal *detailDeal;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MTDetailDealViewController
#pragma mark - 初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BgColor;

    
    //根据数据，设置页面相关的显示
//边界测试    self.deal.purchase_deadline = @"2016-04-20";
    [self.remainTime setTitle:[self remainTime:self.deal.purchase_deadline] forState:UIControlStateNormal];
    [self.soldNumbers setTitle:[NSString stringWithFormat:@"已售%d件",self.deal.purchase_count] forState:UIControlStateNormal];
    [self.dealImg sd_setImageWithURL:[NSURL URLWithString:self.deal.image_url]];
    self.dealDesc.text = self.deal.desc;
    self.dealTitle.text = self.deal.title;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL selected  = [MTCollectDealTool isCollected:self.deal];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.collect.selected = selected;
        });
    });
//    self.collect.selected = YES;
    [self loadDetailDeal];
    
    //webview 的loadRequest： 是异步请求
    NSURLRequest *request =  [NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]];
    [self.detailWebView loadRequest:request];
    self.detailWebView.delegate = self;
    
}
- (IBAction)collect:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        //1. 收藏数据，将数据保存在数据库中
        [MTCollectDealTool addDeal:self.detailDeal];
        [MBProgressHUD showSuccess:@"收藏成功！" toView:self.view];
    }
    else
    {
        //2. 取消收藏，将数据从数据库中删除
        [MTCollectDealTool removeDeal:self.detailDeal];
        [MBProgressHUD showError:@"取消收藏！" toView:self.view];
    }
 
}


- (void)setDetailDeal:(MTDeal *)detailDeal
{
    _detailDeal = detailDeal;
    
    self.freetimeRefound.selected = detailDeal.restrictions.is_refundable;
    self.expiredRefound.selected = detailDeal.restrictions.is_refundable;
}
- (NSString *)remainTime:(NSString *)time_t {
    
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *deadDate = [fmt dateFromString:time_t];
    deadDate = [deadDate dateByAddingTimeInterval:24*60*60];
    NSDate *date = [NSDate date];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calender components:NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date toDate:deadDate options:0];
    if (dateComponents.day > 30) {
        return @"一月后过期";
    }else
    {
        return [NSString stringWithFormat:@"%d天%d小时%d分",dateComponents.day,dateComponents.hour,dateComponents.minute];
    }
    
}
#pragma mark - 请求订单详情数据
- (void)loadDetailDeal
{
    DPAPI *dp = [[DPAPI alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deal_id"] = self.deal.deal_id;
    [dp requestWithURL:@"v1/deal/get_single_deal" params:params delegate:self];
}

#pragma mark - DP request delegate
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (error != nil) {
        JWLog(@"%@",error);
        JWLog(@"%@",request.params);
    }
}
-(void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    self.detailDeal = [MTDeal mj_objectWithKeyValues:[result[@"deals"] lastObject]];
}

#pragma mark - 导航栏返回方法
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIWebView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
  
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    //内部自动进行了跳转逻辑，当第二次访问的时候返回了我们想要的结果
    if (![webView.request.URL.absoluteString isEqualToString:self.deal.deal_url]) {
        
//        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].outerHTML;"];
//        [html writeToFile:@"/Users/JW/Desktop/hello.html" atomically:NO encoding:NSUTF8StringEncoding error:nil];
        NSString *js = [NSString stringWithFormat:@"\
                        var header = document.getElementsByTagName('header')[0];\
                        header.parentNode.removeChild(header);\
                        var de = document.getElementsByClassName('footer-open')[0];\
                        de.parentNode.removeChild(de);\
                        var by = document.getElementsByClassName('last')[0];\
                        by.parentNode.removeChild(by);\
                        var foo = document.getElementsByTagName('footer')[0];\
                        foo.parentNode.removeChild(foo);\
                        var hid = document.getElementsByClassName('footer-fix Hide')[0];\
                        hid.parentNode.removeChild(hid);\
                        var fix = document.getElementsByClassName('footer-btn-fix')[0];\
                        fix.parentNode.removeChild(fix);\
                        var buynow = document.getElementsByClassName('buy-now')[0];\
                        buynow.parentNode.removeChild(buynow);\
                        "];
        [webView stringByEvaluatingJavaScriptFromString:js];
        [self.activityIndicator stopAnimating];
    }
}


//#pragma mark - 生命周期测试
//-(void)loadView
//{
//    [super loadView];
//    self.view = [[[NSBundle mainBundle]loadNibNamed:@"MTDetailDealViewController" owner:self options:nil]lastObject];
//    JWLog(@"");
//}
//-(instancetype)init{
//    if (self = [super init]) {
//        JWLog(@"");
//    }
//    return self;
//}
//-(instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder]) {
//        JWLog(@"");
//    }
//    return self;
//}
//初始化将会先调用该方法
//???: 这个地方有点意思：self.detailWebView = nil；得回来好好看看
//-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        UIColor *color = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
//        //self.detailWebView = nil 这时候
//        self.detailWebView.backgroundColor = color;
//        JWLog(@"");
//    }
//    return  self;
//}
////全程都没有调用该方法
//-(void)viewDidLoad
//{
//    [super viewDidLoad];
//    JWLog(@"");
//}
@end
