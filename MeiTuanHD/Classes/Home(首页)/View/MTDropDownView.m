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
@property (assign, nonatomic) NSInteger selectedRowInMasterCell;

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

+(instancetype)dropDownView
{
    MTDropDownView *dropDown = [[[NSBundle mainBundle]loadNibNamed:@"MTDropDownView" owner:self options:nil] lastObject];
    dropDown.autoresizingMask = UIViewAutoresizingNone;
    return dropDown;
}

#pragma mark - UITableView data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.masterTBV) {
        if ([self.dataSource respondsToSelector:@selector(numberOfRowsInMasterTable:)]) {
            return [self.dataSource numberOfRowsInMasterTable:self];
        }
    }else{
        if ([self.dataSource respondsToSelector:@selector(numberOfRowsInDetailTable:inMasterRow:)]) {
            return [self.dataSource numberOfRowsInDetailTable:self inMasterRow:self.selectedRowInMasterCell];
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell  = [MTDropDownViewMasterCell dropDownViewMasterCellWithTableView:tableView];
    if (tableView == self.masterTBV) {
        if ([self.dataSource respondsToSelector:@selector(dropDownView:titleForRowAtMasterTable:)]) {
            cell.textLabel.text =  [self.dataSource dropDownView:self titleForRowAtMasterTable:indexPath.row];
        }
        if ([self.dataSource respondsToSelector:@selector(dropDownView:imageForRowAtMasterTable:)]) {
            cell.imageView.image =  [self.dataSource dropDownView:self imageForRowAtMasterTable:indexPath.row];
        }
        if ([self.dataSource respondsToSelector:@selector(dropDownView:cellAccessoryTypeForRowAtMasterTable:)]) {
            cell.accessoryType =  [self.dataSource dropDownView:self cellAccessoryTypeForRowAtMasterTable:indexPath.row];
        }
    }else{
        cell = [MTDropDownViewDetailCell dropDownViewDetailCellWithTableView:tableView];
        if ([self.dataSource respondsToSelector:@selector(dropDownView:titleForRowAtDetailTable:inMasterRow:)]) {
            cell.textLabel.text =  [self.dataSource dropDownView:self titleForRowAtDetailTable:indexPath.row inMasterRow:self.selectedRowInMasterCell];
        }
    }
    return cell;
}
#pragma mark - tableView delegate method
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.masterTBV) {
        self.selectedRowInMasterCell = indexPath.row;
        [self.detailTBV reloadData];
    }
}
@end
