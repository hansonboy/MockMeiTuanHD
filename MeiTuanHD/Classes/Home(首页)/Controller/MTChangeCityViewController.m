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
#import "MTMetaTool.h"
#import "MTSearchResultTVC.h"
@interface MTChangeCityViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic ,weak)MTSearchResultTVC *resultTVC;

@end

@implementation MTChangeCityViewController
const int coverTag = 1000;
#pragma mark - 懒加载


#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    
    [self setupSearchResultTVC];
    
}
-(void)setupNavigationBar
{
    //setup navigationBar
    self.title = @"切换城市";
    UIBarButtonItem *item = [UIBarButtonItem itemWithTarget:self action:@selector(dismiss) imageName:@"btn_navigation_close" selecteImageName:@"btn_navigation_close_hl"];
    self.navigationItem.leftBarButtonItem = item;
    self.view.autoresizingMask = UIViewAutoresizingNone;
}
-(void)setupSearchResultTVC
{
    MTSearchResultTVC *tvc = [[MTSearchResultTVC alloc]init];
    [self addChildViewController:tvc];
    self.resultTVC = tvc;
    [self.view addSubview:self.resultTVC.view];
    [self.resultTVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.searchBar.mas_bottom).offset(10);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.resultTVC.view.alpha = 0.1;
}
-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - tableview data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return  [MTMetaTool cityGroups].count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MTCityGroup *group =  [[MTMetaTool cityGroups] objectAtIndex:section];
    return group.cities.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    MTCityGroup *cityGroup = [ [MTMetaTool cityGroups] objectAtIndex:indexPath.section];
   
    cell.textLabel.text =  [cityGroup.cities objectAtIndex:indexPath.row];
    return cell;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[ [MTMetaTool cityGroups] objectAtIndex:section] title];
}
#pragma mark - tableview delegate
//索引
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return    [ [MTMetaTool cityGroups] valueForKeyPath:@"title"];
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

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    JWLog(@"searchText: %@",searchText);
    self.resultTVC.view.alpha = 1;
    [self.view bringSubviewToFront:self.resultTVC.view];
    self.resultTVC.result = [MTMetaTool citiesWithSearchText:searchText];
    if (searchText.length == 0) {
        self.resultTVC.view.alpha = 0;
    }
}

@end
