//
//  MTDropDownView.h
//  MeiTuanHD
//
//  Created by wangjianwei on 16/3/29.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTDropDownView;
@protocol MTDropDownViewDataSource <NSObject>
@required
/** 主表中行的数量*/
-(NSInteger)numberOfRowsInMasterTable:(MTDropDownView *)dropDownView;
/** 从表中行的数量*/
-(NSInteger)numberOfRowsInDetailTable:(MTDropDownView *)dropDownView inMasterRow:(NSInteger)masterRow;
/** 主表中行的标题*/
-(NSString *)dropDownView:(MTDropDownView *)dropDownView titleForRowAtMasterTable:(NSInteger)row;
/** 从表中行的标题*/
-(NSString *)dropDownView:(MTDropDownView *)dropDownView titleForRowAtDetailTable:(NSInteger)row inMasterRow:(NSInteger)masterRow;

@optional
/** 主表中行的图片*/
-(UIImage *)dropDownView:(MTDropDownView *)dropDownView imageForRowAtMasterTable:(NSInteger)row;
/** 主表中行的accessoryType*/
-(UITableViewCellAccessoryType)dropDownView:(MTDropDownView *)dropDownView cellAccessoryTypeForRowAtMasterTable:(NSInteger)row;

@end

@interface MTDropDownView : UIView

/** 数据源*/
@property (weak,nonatomic) id<MTDropDownViewDataSource> dataSource;

@property (strong,nonatomic) NSArray *categories;

+(instancetype)dropDownView;

@end
