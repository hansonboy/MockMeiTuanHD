//
//  MTRegion.h
//  MTHD
//
//  Created by wangjianwei on 16/4/10.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTRegion : NSObject
/**区域名称*/
@property (nonatomic ,copy) NSString *name;
/**子区域名称数组，数组内元素是NSString*/
@property (nonatomic ,strong)NSArray *subregions;

@end
