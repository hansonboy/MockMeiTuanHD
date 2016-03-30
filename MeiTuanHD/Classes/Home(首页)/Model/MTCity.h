//
//  MTCity.h
//  MeiTuanHD
//
//  Created by wangjianwei on 16/3/31.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTCity : NSObject

/**城市名称*/
@property (nonatomic ,copy) NSString *name;
/**城市名称拼音*/
@property (nonatomic ,copy) NSString *pinYin;
/**城市名称拼音头部*/
@property (nonatomic ,copy) NSString *pinYinHead;
/**该城市包含的地区*/
@property (strong,nonatomic) NSArray *regions;

@end
