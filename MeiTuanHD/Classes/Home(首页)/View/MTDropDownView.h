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

@protocol MTDropDownViewDelegate <NSObject>

@optional
///**点击主表某一行的代理事件*/ 将两者进行合并
//-(void)dropDownView:(MTDropDownView *)dropDownView didSelectRowAtMasterTable:(NSInteger)row;
/**点击从表中某一行中的代理事件*/
-(void)dropDownView:(MTDropDownView *)dropDownView didSelectRowAtMasterTable:(NSInteger)masterRow detailTableAtRow:(NSInteger)detailRow;

@end
@interface MTDropDownView : UIView

/** 数据源*/
@property (weak,nonatomic) id<MTDropDownViewDataSource> dataSource;
/** 代理*/
@property (weak,nonatomic) id<MTDropDownViewDelegate> delegate;

@property (strong,nonatomic) NSArray *categories;

+(instancetype)dropDownView;

@end
