
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

@interface MTDetailDealViewController ()
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

@end

@implementation MTDetailDealViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    
}
-(void)setDeal:(MTDeal *)deal
{
    _deal = deal;
//    self.freetimeRefound.selected = deal.
    JWLog(@"");
    
    [self.remainTime setTitle:[self remainTime:deal.purchase_deadline] forState:UIControlStateNormal];
    
    [self.soldNumbers setTitle:[NSString stringWithFormat:@"已售%d件",deal.purchase_count] forState:UIControlStateNormal];
    [self.dealImg sd_setImageWithURL:[NSURL URLWithString:deal.image_url]];
    self.dealDesc.text = deal.desc;
    self.dealTitle.text = deal.title;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (NSString *)remainTime:(NSString *)time_t {
    
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        fmt.dateFormat = @"yyyy-MM-dd";
        NSDate *deadDate = [fmt dateFromString:time_t];
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
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 生命周期测试
-(void)loadView
{
    [super loadView];
    self.view = [[[NSBundle mainBundle]loadNibNamed:@"MTDetailDealViewController" owner:self options:nil]lastObject];
    JWLog(@"");
}
-(instancetype)init{
    if (self = [super init]) {
        JWLog(@"");
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        JWLog(@"");
    }
    return self;
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
   {
       JWLog(@"");
   }
    return self;
}
@end
