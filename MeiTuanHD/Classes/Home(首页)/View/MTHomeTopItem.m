//
//  MTHomeTopItem.m
//  MeiTuanHD
//
//  Created by wangjianwei on 16/3/29.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTHomeTopItem.h"
@interface MTHomeTopItem()
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end
@implementation MTHomeTopItem
-(instancetype)init{
    MTHomeTopItem *item = [[[NSBundle mainBundle]loadNibNamed:@"MTHomeTopItem" owner:self options:nil] lastObject];
    item.autoresizingMask = UIViewAutoresizingNone;

    return item;
}
+(instancetype)itemWithTopTitle:(NSString *)topTitle bottomTitle:(NSString *)bottomTitle image:(NSString *)image highlightedImage:(NSString *)hlImage{
    MTHomeTopItem *item = [[self alloc]init];
    item.topLabel.text = topTitle;
    item.bottomLabel.text = bottomTitle;
    [item.btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [item.btn setImage:[UIImage imageNamed:hlImage] forState:UIControlStateHighlighted];
    return item;
}
-(void)addTarget:(id)target action:(SEL)action{
    [self.btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
@end
