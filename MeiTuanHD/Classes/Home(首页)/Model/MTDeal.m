//
//  MTDeal.m
//  MTHD
//
//  Created by wangjianwei on 16/4/12.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTDeal.h"
#import "MJExtension.h"

@implementation MTDeal
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"desc":@"description"};
}
MJCodingImplementation
- (BOOL)isEqual:(MTDeal *)object
{
    return [self.deal_id isEqualToString:object.deal_id];
}
@end
