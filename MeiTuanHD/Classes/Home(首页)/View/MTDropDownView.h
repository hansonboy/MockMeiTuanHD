//
//  MTDropDownView.h
//  MeiTuanHD
//
//  Created by wangjianwei on 16/3/29.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTDropDownView : UIView
/** 数据源*/
@property (strong,nonatomic) NSArray *categories;

+(instancetype)dropDownView;

@end
