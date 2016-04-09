//
//  MTDropDownView.m
//  MeiTuanHD
//
//  Created by wangjianwei on 16/3/29.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTDropDownView.h"
#import "MJExtension.h"
#import "MTCategory.h"
#import "MTDropDownViewMasterCell.h"
#import "MTDropDownViewDetailCell.h"
@interface MTDropDownView()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *masterTBV;
@property (weak, nonatomic) IBOutlet UITableView *detailTBV;
@property (weak, nonatomic) MTCategory *selectedCategory;

@end
@implementation MTDropDownView
#pragma mark 测试下什么时候会调用awakeFromNib：自定义view时候，会先调用initWithCoder:，然后是awakeFromNib 方法
-(void)awakeFromNib{
    [super awakeFromNib];
    JWLog(@"");
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]) {
        JWLog(@"");
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        JWLog(@"");
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    JWLog(@"");
}
-(NSArray *)categories{
    if (_categories == nil) {
        [MTCategory mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"subcategories":@"NSString"};
        }];
        _categories = [MTCategory mj_objectArrayWithFilename:@"categories.plist"];
    }
    return _categories;
}
+(instancetype)dropDownView
{
    MTDropDownView *dropDown = [[[NSBundle mainBundle]loadNibNamed:@"MTDropDownView" owner:self options:nil] lastObject];
    dropDown.autoresizingMask = UIViewAutoresizingNone;
    return dropDown;
}

#pragma mark - UITableView data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.masterTBV) {
        return self.categories.count;
    }else{
        //detailTVB的dataSource
        return self.selectedCategory.subcategories.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell  = [MTDropDownViewMasterCell dropDownViewMasterCellWithTableView:tableView];
    if (tableView == self.masterTBV) {
        MTCategory * category = [self.categories objectAtIndex:indexPath.row];
        cell.textLabel.text = category.name;
        cell.imageView.image = [UIImage imageNamed:category.small_icon];
        if (category.subcategories) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else{
        cell = [MTDropDownViewDetailCell dropDownViewDetailCellWithTableView:tableView];
        
        NSArray *dataSourceD = self.selectedCategory.subcategories;
        cell.textLabel.text = [dataSourceD objectAtIndex:indexPath.row];
    }
    return cell;
}
#pragma mark - tableView delegate method
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.masterTBV) {
        self.selectedCategory = [self.categories objectAtIndex:indexPath.row];
        [self.detailTBV reloadData];
    }
}
@end
