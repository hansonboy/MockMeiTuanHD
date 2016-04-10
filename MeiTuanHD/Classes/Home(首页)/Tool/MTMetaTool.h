//
//  MTMetaTool.h
//  MTHD
//
//  Created by wangjianwei on 16/4/10.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTMetaTool : NSObject
+(NSArray *)cityGroups;
+(NSArray *)categories;
+(NSArray *)cities;
+(NSArray*)citiesWithSearchText:(NSString *)searchText;
@end
