//
//  MTChangeCityViewController.h
//  MeiTuanHD
//
//  Created by wangjianwei on 16/3/30.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kMTCityWillChangeNotification;
extern NSString *const kMTRegionDidChangedNotification;

extern NSString *const kMTRegionSelectedCityIndexUserInfoKey;
extern NSString *const kMTRegionSelectedRegionIndexUserInfoKey ;
extern NSString *const kMTRegionSelectedSubRegionIndexUserInfoKey;

@interface MTRegionViewController : UIViewController
/** 当前选中的城市*/
@property (nonatomic ,assign)NSInteger selectedCityIndex;
/** 当前选中的区域*/
@property (nonatomic ,assign)NSInteger selectedRegionIndex;
/** 当前选中的子区域*/
@property (nonatomic ,assign)NSInteger selectedSubregionIndex;
@end
