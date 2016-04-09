//
//  MTDropDownViewMasterCell.m
//  MTHD
//
//  Created by wangjianwei on 16/4/9.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTDropDownViewMasterCell.h"

@implementation MTDropDownViewMasterCell

+(instancetype)dropDownViewMasterCellWithTableView:(UITableView *)tableView
{
    static NSString *identifier =@"master_cell";
    MTDropDownViewMasterCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MTDropDownViewMasterCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_leftpart"]];
        self.selectedBackgroundView = [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];
    }
    return self;
}

@end
