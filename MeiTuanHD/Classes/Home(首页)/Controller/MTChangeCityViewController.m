//
//  MTChangeCityViewController.m
//  MeiTuanHD
//
//  Created by wangjianwei on 16/3/30.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTChangeCityViewController.h"
#import "UIBarButtonItem+Extension.h"
@interface MTChangeCityViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation MTChangeCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"切换城市";
    UIBarButtonItem *item = [UIBarButtonItem itemWithTarget:self action:@selector(dismiss) imageName:@"btn_navigation_close" selecteImageName:@"btn_navigation_close_hl"];
    self.navigationItem.leftBarButtonItem = item;
    self.view.autoresizingMask = UIViewAutoresizingNone;
//    self.modalPresentationStyle = UIModalPresentationPageSheet;

}
-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - tableview data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    }
    return cell;
}
@end
