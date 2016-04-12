
//
//  MTCenterLineLabel.m
//  MTHD
//
//  Created by wangjianwei on 16/4/12.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTCenterLineLabel.h"

@implementation MTCenterLineLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    UIRectFill(CGRectMake(0, 0.25*rect.size.height, rect.size.width,1));
}


@end
