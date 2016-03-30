//
//  MTCategory.h
//  MeiTuanHD
//
//  Created by wangjianwei on 16/3/30.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTCategory : NSObject

/** 图片名称*/
@property (nonatomic ,copy) NSString *icon;
/** 类别名称*/
@property (nonatomic ,copy) NSString *name;
/** 高亮小图名称*/
@property (nonatomic ,copy) NSString *small_highlighted_icon;
/** 小图名称*/
@property (nonatomic ,copy) NSString *small_icon;
/** 地图名称*/
@property (nonatomic ,copy) NSString *map_icon;
/** 子类名称*/
@property (strong,nonatomic) NSArray *subcategories;

@end
