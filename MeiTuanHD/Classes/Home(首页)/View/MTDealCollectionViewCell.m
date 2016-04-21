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
/**是否正在编辑*/
@property (weak, nonatomic) IBOutlet UIButton *isEditing;
/**是否被选中*/
@property (weak, nonatomic) IBOutlet UIImageView *isSelectedImageView;

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
    if ([now compare:deal.publish_date]!= NSOrderedDescending) {
        self.dealNew.hidden = NO;
    }else{
        self.dealNew.hidden = YES;
    }
    
    self.isEditing.hidden = !self.deal.isEditing;
    self.isSelectedImageView.hidden = !self.deal.isSelected;
}

- (IBAction)didClick{
    self.isSelectedImageView.hidden = !self.isSelectedImageView.hidden;
    self.deal.selected = !self.deal.selected;
    JWLog(@"%@",self.deal);
    if ([self.delegate respondsToSelector:@selector(dealCollectionViewCellDidSelectOrNot:)]) {
        [self.delegate dealCollectionViewCellDidSelectOrNot:self];
    }
}

@end
