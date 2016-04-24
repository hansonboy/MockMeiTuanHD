
//
//  MTBusinessAnnotation.m
//  MTHD
//
//  Created by wangjianwei on 16/4/22.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTBusinessAnnotation.h"

@implementation MTBusinessAnnotation
//-(NSString *)description
//{
//    return [NSString stringWithFormat:@"%@-%@-%p",self.title,self.subtitle,self];
//}
- (BOOL)isEqual:(MTBusinessAnnotation *)object {

    return [self.title isEqualToString:object.title];
}
@end
