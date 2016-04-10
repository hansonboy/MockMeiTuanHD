//
//  MTSetCatogeryViewController.m
//  MeiTuanHD
//
//  Created by wangjianwei on 16/3/29.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTCatogeryViewController.h"
#import "MTDropDownView.h"
#import "MTCategory.h"
#import "MTMetaTool.h"
@interface MTCatogeryViewController ()<MTDropDownViewDataSource>

@end

@implementation MTCatogeryViewController
//因为MTCatogeryViewController.view 只有一个DropDownView ，所以可以将self.view 和MTDropDownView 进行合并，一个控制器的view的加载过程是先调用loadView 为self.view 赋值，如果没有重写该方法，那么会找是否存在和控制器同名的xib，或者是storyBoard来进行初始化，如果都没有，那会初始化一个空白的view 赋值给self.view
-(void)loadView
{
     MTDropDownView *dropView = [MTDropDownView dropDownView];
    self.view = dropView;
    dropView.dataSource = self;
    self.preferredContentSize = dropView.frame.size;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark -MTDropDownViewDataSource
/** 主表中行的数量*/
-(NSInteger)numberOfRowsInMasterTable:(MTDropDownView *)dropDownView
{
    return [MTMetaTool categories].count;
}
/** 从表中行的数量*/
-(NSInteger)numberOfRowsInDetailTable:(MTDropDownView *)dropDownView inMasterRow:(NSInteger)masterRow
{
    return [[MTMetaTool categories][masterRow] subcategories].count;
}
/** 主表中行的标题*/
-(NSString *)dropDownView:(MTDropDownView *)dropDownView titleForRowAtMasterTable:(NSInteger)row
{
     return [[[MTMetaTool categories] objectAtIndex:row] name];
}
/** 从表中行的标题*/
-(NSString *)dropDownView:(MTDropDownView *)dropDownView titleForRowAtDetailTable:(NSInteger)row inMasterRow:(NSInteger)masterRow
{
    return [[[MTMetaTool categories][masterRow] subcategories] objectAtIndex:row];
}

/** 主表中行的图片名称*/
-(UIImage *)dropDownView:(MTDropDownView *)dropDownView imageForRowAtMasterTable:(NSInteger)row
{
    return [UIImage imageNamed:[[[MTMetaTool categories] objectAtIndex:row] small_icon]];
}
/** 主表中行的accessoryType*/
-(UITableViewCellAccessoryType)dropDownView:(MTDropDownView *)dropDownView cellAccessoryTypeForRowAtMasterTable:(NSInteger)row
{
    if ([[[[MTMetaTool categories] objectAtIndex:row] subcategories] count] == 0) {
        return UITableViewCellAccessoryNone;
    }else
        return UITableViewCellAccessoryDisclosureIndicator;
}

@end
