//
//  UIBarButtonItem+Extension.m
//  微博
//
//  Created by wangjianwei on 15/12/9.
//  Copyright © 2015年 JW. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
@implementation UIBarButtonItem (Extension)
+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action imageName:(NSString *)imageName selecteImageName:(NSString *)selectedImageName{
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateHighlighted];
    button.size = button.currentImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}
@end
