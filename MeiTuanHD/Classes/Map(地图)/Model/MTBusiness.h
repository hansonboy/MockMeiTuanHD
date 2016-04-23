//
//  MTBusiness.h
//  MTHD
//
//  Created by wangjianwei on 16/4/22.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTBusiness : NSObject
/** 商户名*/
@property (nonatomic ,copy) NSString *name;
/** 商户ID*/
@property (nonatomic ,assign)int business_id;
/** 商户页链接*/
@property (nonatomic ,copy) NSString *url;
/** 商户页链接 h5*/
@property (nonatomic ,copy) NSString *h5_url;
/** 维度*/
@property (nonatomic ,assign)double latitude;
/** 经度*/
@property (nonatomic ,assign)double longitude;
/** 城市*/
@property (nonatomic ,copy) NSString *city;

@end
