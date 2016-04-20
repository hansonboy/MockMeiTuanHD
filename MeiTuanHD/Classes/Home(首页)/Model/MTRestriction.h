//
//  MTRestriction.h
//  MTHD
//
//  Created by wangjianwei on 16/4/20.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTRestriction : NSObject
/** 附加信息(一般为团购信息的特别提示) */
@property (nonatomic ,copy) NSString *special_tips;
/**	是否支持随时退款，0：不是，1：是*/
@property (nonatomic ,assign)BOOL is_refundable;
/**	是否需要预约，0：不是，1：是*/
@property (nonatomic ,assign)BOOL is_reservation_required;

@end
