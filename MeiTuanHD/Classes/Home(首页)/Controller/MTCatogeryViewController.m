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
#import "MJExtension.h"
@interface MTCatogeryViewController ()

//@property (weak,nonatomic) MTDropDownView *dropView;

@end

@implementation MTCatogeryViewController
//因为MTCatogeryViewController.view 只有一个DropDownView ，所以可以将self.view 和MTDropDownView 进行合并，一个控制器的view的加载过程是先调用loadView 为self.view 赋值，如果没有重写该方法，那么会找是否存在和控制器同名的xib，或者是storyBoard来进行初始化，如果都没有，那会初始化一个空白的view 赋值给self.view
-(void)loadView
{
     MTDropDownView *dropView = [MTDropDownView dropDownView];
    self.view = dropView;
    self.preferredContentSize = dropView.frame.size;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    MTDropDownView *dropView = [MTDropDownView dropDownView];
//    [self.view addSubview:dropView];
//    self.dropView = dropView;
//    self.preferredContentSize = self.dropView.frame.size;
    
}



@end
