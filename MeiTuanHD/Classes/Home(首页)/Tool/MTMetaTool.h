//
//  MTMetaTool.h
//  MTHD
//
//  Created by wangjianwei on 16/4/10.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MTCategory;
@class MTCity;

@interface MTMetaTool : NSObject
+(NSArray *)cityGroups;
+(NSArray *)categories;
+(MTCategory *)categoryByIndex:(NSInteger)index;
+(NSArray *)cities;
+(MTCity *)cityByIndex:(NSInteger)index;
/** 返回的是包含搜索字符串的选中下标集合*/
+(NSArray *)citiesWithSearchText:(NSString *)searchText;
/** 返回的是sort.plist中的MTSort对象*/
+(NSArray *)sorts;
@end
