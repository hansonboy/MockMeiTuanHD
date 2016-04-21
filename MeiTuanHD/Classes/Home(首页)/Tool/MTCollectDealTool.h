//
//  MTDealTool.h
//  MTHD
//
//  Created by wangjianwei on 16/4/20.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTDeal.h"

@interface MTCollectDealTool : NSObject
+ (NSInteger)pageCount;
+ (NSArray *)loadDealsByPage:(NSInteger)page;
+ (NSArray *)allDeals;
+ (BOOL)addDeal:(MTDeal *)deal;
+ (BOOL)removeDeal:(MTDeal *)deal;
+ (BOOL)isCollected:(MTDeal *)deal;
+ (BOOL)clearDeals;
+ (void)test;
@end
