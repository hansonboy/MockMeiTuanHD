//
//  MTSortViewController.m
//  MTHD
//
//  Created by wangjianwei on 16/4/11.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTSortViewController.h"
#import "MTSort.h"
#import "MTMetaTool.h"
@interface MTSortViewController ()

@end
NSString *const kMTSortViewControllerDidNewSortNotification = @"kMTSortViewControllerDidNewSortNotification";
NSString *const kMTSortNumberUserInfoKey = @"kMTSortNumberUserInfoKey";
@implementation MTSortViewController
#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidLayoutSubviews
{
    CGFloat btnYM = 10;
    CGFloat btnXM = 10;
    CGFloat btnX = btnXM ;
    CGFloat btnY = 0;
    CGFloat btnW = 120;
    CGFloat btnH = 40;
    NSArray *sorts = [MTMetaTool sorts];
    CGFloat count = sorts.count;
    MTSort *sort ;
    
    for (int i = 0; i< count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        [btn addTarget:self action:@selector(clickSort:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        btnY = (btnH + btnYM)*i;
        btn.frame  = CGRectMake(btnX, btnY, btnW, btnH);
        sort = [sorts objectAtIndex:i];
        [btn setTitle:sort.label forState:UIControlStateNormal];
        [btn setTitle:sort.label forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.view addSubview:btn];
    }
    UIButton *btn = [self.view.subviews lastObject];
    self.preferredContentSize = CGSizeMake(btnW+2*btnXM,CGRectGetMaxY(btn.frame)+btnYM);
}
-(void)clickSort:(UIButton *)btn
{

    [KNotificationCenter postNotificationName:kMTSortViewControllerDidNewSortNotification object:self userInfo:@{kMTSortNumberUserInfoKey:@(btn.tag)}];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
