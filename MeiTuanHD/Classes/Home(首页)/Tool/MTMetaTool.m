
//
//  MTMetaTool.m
//  MTHD
//
//  Created by wangjianwei on 16/4/10.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTMetaTool.h"
#import "MTCityGroup.h"
#import "MTCity.h"
#import "MTRegion.h"
#import "MTCategory.h"
#import "MJExtension.h"
static MTMetaTool *tool = nil;
@interface MTMetaTool()<NSCopying,NSMutableCopying>
@property (strong,nonatomic) NSArray *citiGroups;
@property (strong,nonatomic) NSArray *categories;
@property (nonatomic ,strong)NSArray *cities;
@end
@implementation MTMetaTool
+(void)initialize
{
    if (self == [MTMetaTool self]) {
        tool = [[self alloc]init];
    }
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    if(tool == nil)
    {
        tool = [super allocWithZone:zone];
    }
    return tool;
}
-(instancetype)copyWithZone:(struct _NSZone *)zone
{
    return tool;
}
-(instancetype)mutableCopyWithZone:(NSZone *)zone
{
    return tool;
}
+(NSArray *)cityGroups
{
    if (tool.citiGroups == nil) {
       tool.citiGroups = [MTCityGroup mj_objectArrayWithFilename:@"cityGroups.plist"];
    }
    return tool.citiGroups;
}
+(NSArray *)categories{
    if (tool.categories == nil) {
        [MTCategory mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"subcategories":@"NSString"};
        }];
        tool.categories = [MTCategory mj_objectArrayWithFilename:@"categories.plist"];
    }
    return tool.categories;
}
+(NSArray *)cities
{
    if( tool.cities == nil)
    {
        [MTCity setupObjectClassInArray:^NSDictionary *{
            return @{@"regions":@"MTRegion"};
        }];
        tool.cities = [MTCity mj_objectArrayWithFilename:@"cities.plist"];
    }
    return tool.cities;
}
+(NSArray *)citiesWithSearchText:(NSString *)searchText
{
    searchText = searchText.lowercaseString;
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0;i < [self cities].count;i++) {
        MTCity *city = [[self cities]objectAtIndex:i];
        if ([city.name containsString:searchText] ||[city.pinYin containsString:searchText] || [city.pinYinHead containsString:searchText]) {
            [result addObject:@(i)];
        }
    }
    return  result;
}
@end
