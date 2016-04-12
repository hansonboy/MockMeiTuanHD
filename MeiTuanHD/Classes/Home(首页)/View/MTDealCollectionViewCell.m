//
//  MTDealCollectionViewCell.m
//  MTHD
//
//  Created by wangjianwei on 16/4/12.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTDealCollectionViewCell.h"
#import "MTDeal.h"
#import "UIImageView+WebCache.h"
@interface MTDealCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *dealImage;
@property (weak, nonatomic) IBOutlet UILabel *dealTitle;
@property (weak, nonatomic) IBOutlet UILabel *dealDesc;
@property (weak, nonatomic) IBOutlet UILabel *dealCurrentPrice;
@property (weak, nonatomic) IBOutlet UILabel *dealPrimativePrice;
@property (weak, nonatomic) IBOutlet UILabel *dealCount;
@property (weak, nonatomic) IBOutlet UIImageView *dealNew;
@end
@implementation MTDealCollectionViewCell
-(instancetype)init
{
    return [[[NSBundle mainBundle]loadNibNamed:@"MTDealCollectionViewCell" owner:nil options:nil] lastObject];
}
-(void)setDeal:(MTDeal *)deal
{
    _deal = deal;
    [self.dealImage sd_setImageWithURL:[NSURL URLWithString:deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    self.dealTitle.text = deal.title;
    self.dealDesc.text = deal.desc;

    self.dealCurrentPrice.text = [NSString stringWithFormat:@"￥%@",deal.current_price];
    self.dealPrimativePrice.text = [NSString stringWithFormat:@"￥%@",deal.list_price];
    self.dealCount.text = [NSString stringWithFormat:@"已售%d",deal.purchase_count];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *now = [fmt stringFromDate:[NSDate date]];
    JWLog(@"%@-%@",now,deal.publish_date);
    if ([now compare:deal.publish_date]!= NSOrderedDescending) {
        self.dealNew.hidden = NO;
    }else{
        self.dealNew.hidden = YES;
    }
}
@end
