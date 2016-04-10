//
//  MTCityGroup.h
//  MeiTuanHD
//
//  Created by wangjianwei on 16/3/31.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTCityGroup : NSObject
/**分组名称*/
@property (nonatomic ,copy) NSString *title;
/**包含的城市数组，数组内部包含的类型是NSString*/
@property (strong,nonatomic) NSArray *cities;

@end
