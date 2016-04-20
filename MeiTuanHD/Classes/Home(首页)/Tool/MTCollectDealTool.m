//
//  MTDealTool.m
//  MTHD
//
//  Created by wangjianwei on 16/4/20.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTCollectDealTool.h"
#import "FMDB.h"
@interface MTCollectDealTool()

@end
static FMDatabase *dealDataBase;
@implementation MTCollectDealTool
+(void)initialize
{
    if (self == [MTCollectDealTool self]) {
        
        NSString *fileName = [kMTCacheDir stringByAppendingPathComponent:@"deal.Collect"];
        dealDataBase = [FMDatabase databaseWithPath:fileName];
        if (![dealDataBase open]) {
            JWLog(@"无法打开或者初始化fmdb：%@",[dealDataBase lastErrorMessage]);
            return;
        }
        if (![dealDataBase executeUpdate:@"create table if not exists collect(id auto increment pimary key,deal blob,deal_id txt not null);"]) {
            JWLog(@"创建表失败：%@",[dealDataBase lastErrorMessage]);
        }
    }
}
+(NSArray *)allDeals
{
    NSMutableArray *result = [NSMutableArray array];
    FMResultSet *rs = [dealDataBase executeQuery:@"select * from collect;"];
    while (rs.next) {
        NSData *data = [rs objectForColumnName:@"deal"];
        MTDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [result addObject:deal];
    }
    return  result;
}
+ (BOOL)addDeal:(MTDeal *)deal
{
    [self removeDeal:deal];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    if (![dealDataBase executeUpdateWithFormat:@"insert into collect(deal,deal_id) values(%@,%@);",data,deal.deal_id]) {
        JWLog(@"更新数据有误：%@",[dealDataBase lastErrorMessage]);
        return false;
    }
    return true;
}
+ (BOOL)removeDeal:(MTDeal *)deal
{
    if (![dealDataBase executeUpdateWithFormat:@"delete  from collect where deal_id = %@;",deal.deal_id]) {
        JWLog(@"更新数据有误：%@",[dealDataBase lastErrorMessage]);
        return false;
    }
    return true;
}
+ (BOOL)isCollected:(MTDeal *)deal
{
   
    FMResultSet *rs = [dealDataBase executeQueryWithFormat:@"select count(*) as count_collect  from collect where deal_id = %@;",deal.deal_id];
    [rs next];
    return [rs intForColumn:@"count_collect"] == 1;
}
+ (BOOL)clearDeals
{
    if (![dealDataBase executeUpdateWithFormat:@"delete  from collect"]) {
        JWLog(@"更新数据有误：%@",[dealDataBase lastErrorMessage]);
        return false;
    }
    return true;
}
@end
