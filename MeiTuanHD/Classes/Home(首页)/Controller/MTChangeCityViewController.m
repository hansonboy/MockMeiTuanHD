//
//  MTChangeCityViewController.m
//  MeiTuanHD
//
//  Created by wangjianwei on 16/3/30.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTChangeCityViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MTCity.h"
#import "MJExtension.h"
#import "MTCityGroup.h"
#import "Masonry.h"
@interface MTChangeCityViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) NSArray *cities;
@property (strong,nonatomic) NSArray *citiGroups;
@end

@implementation MTChangeCityViewController
const int coverTag = 1000;
#pragma mark - 懒加载
-(NSArray *)cities{
    if (_cities == nil) {
        _cities = [MTCity mj_objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}
-(NSArray *)citiGroups{
    if (_citiGroups == nil) {
        _citiGroups = [MTCityGroup mj_objectArrayWithFilename:@"cityGroups.plist"];
    }
    return _citiGroups;
}
#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"切换城市";
    UIBarButtonItem *item = [UIBarButtonItem itemWithTarget:self action:@selector(dismiss) imageName:@"btn_navigation_close" selecteImageName:@"btn_navigation_close_hl"];
    self.navigationItem.leftBarButtonItem = item;
    self.view.autoresizingMask = UIViewAutoresizingNone;
}
-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - tableview data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return  self.citiGroups.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MTCityGroup *group =  [self.citiGroups objectAtIndex:section];
    return group.cities.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    MTCityGroup *cityGroup = [self.citiGroups objectAtIndex:indexPath.section];
   
    cell.textLabel.text =  [cityGroup.cities objectAtIndex:indexPath.row];
    return cell;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[self.citiGroups objectAtIndex:section] title];
}
#pragma mark - tableview delegate
//索引
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSArray *titles =  [self.citiGroups valueForKeyPath:@"title"];
    return titles;
}
#pragma mark - searchBar delegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    //1.隐藏导航栏
    [self.navigationController  setNavigationBarHidden:YES animated:YES];
    
//    //3.将tableView用蒙版挡住
    UIView *cover = [[UIView alloc]init];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.5;
    cover.tag = coverTag;
    [self.view addSubview:cover];
    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:searchBar action:@selector(resignFirstResponder)]];
    //使用masonry 添加代码约束
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView.mas_left);
        make.right.equalTo(self.tableView.mas_right);
        make.top.equalTo(self.tableView.mas_top);
        make.bottom.equalTo(self.tableView.mas_bottom);
    }];
//    //2.更改搜索框背景
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    UIView *cover = [self.view viewWithTag:coverTag];
    [cover removeFromSuperview];

    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
}
@end
