//
//  MTSetCatogeryViewController.m
//  MeiTuanHD
//
//  Created by wangjianwei on 16/3/29.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTSetCatogeryViewController.h"
#import "MTDropDownView.h"
#import "MTCategory.h"
#import "MJExtension.h"
@interface MTSetCatogeryViewController ()

@property (weak,nonatomic) MTDropDownView *dropView;

@end

@implementation MTSetCatogeryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MTDropDownView *dropView = [MTDropDownView dropDownView];
    [self.view addSubview:dropView];
    self.dropView = dropView;
    self.preferredContentSize = self.dropView.frame.size;
    
}



@end
