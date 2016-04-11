//
//  NSDictionary+Log.m
//  JW微博JW
//
//  Created by wangjianwei on 15/12/17.
//  Copyright © 2015年 JW. All rights reserved.
//

#import "NSDictionary+Log.h"

@implementation NSDictionary (Log)
-(NSString *)descriptionWithLocale:(id)locale{
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@"{\n"];
    
    // 遍历字典的所有键值对
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [str appendFormat:@"\t%@ = %@,\n", key, obj];
    }];
    
    [str appendString:@"}"];
    
    // 查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length != 0) {
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }
    
    return str;
}
@end
