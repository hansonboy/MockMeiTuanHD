//
//
//  Created by wangjianwei on 15/12/9.
//  Copyright © 2015年 JW. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
-(void)setOrigin:(CGPoint)origin{
    
    CGRect rect = {origin,self.frame.size};
    self.frame = rect;
}
-(CGPoint)origin{
    return self.frame.origin;
}
-(void)setSize:(CGSize)size{
    CGRect rect = {self.frame.origin,size};
    self.frame = rect;
}
-(CGSize)size{
    return self.frame.size;
}
-(CGFloat)x{
    return self.frame.origin.x;
}
-(CGFloat)y{
    return self.frame.origin.y;
}
-(void)setX:(CGFloat)x{
    CGRect rect = {{x,self.frame.origin.y},self.frame.size};
    self.frame = rect;
}
-(void)setY:(CGFloat)y{
    CGRect rect = {{self.frame.origin.x,y},self.frame.size};
    self.frame = rect;
}
-(CGFloat)width{
    return self.frame.size.width;
}
-(CGFloat)height{
    return self.frame.size.height;
}
-(void)setWidth:(CGFloat)width{
    CGRect rect = {self.frame.origin,{width,self.frame.size.height}};
    self.frame = rect;
}
-(void)setHeight:(CGFloat)height{
    CGRect rect = {self.frame.origin,{self.frame.size.width,height}};
    self.frame = rect;
}
-(CGFloat)centerX{
    return self.center.x;
}
-(CGFloat)centerY{
    return self.center.y;
}
-(void)setCenterX:(CGFloat)centerX{
    self.center = CGPointMake(centerX, self.center.y);
}
-(void)setCenterY:(CGFloat)centerY{
    self.center = CGPointMake(self.center.x, centerY);
}
@end
