//
//  MTHomeTopItem.h
//  MeiTuanHD
//
//  Created by wangjianwei on 16/3/29.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTHomeTopItem : UIView

+(instancetype)itemWithTopTitle:(NSString *)topTitle bottomTitle:(NSString *)bottomTitle image:(NSString *)image highlightedImage:(NSString *)hlImage;

-(void)addTarget:(id)target action:(SEL)action;
-(void)setTitle:(NSString*)title;
-(void)setDetailTitle:(NSString *)detailTitle;
-(void)setImage:(NSString *)image highImage:(NSString *)highImg;
@end
