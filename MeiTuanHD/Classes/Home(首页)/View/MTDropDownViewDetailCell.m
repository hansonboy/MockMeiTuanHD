
//
//  MTDropDownViewDetailCell.m
//  MTHD
//
//  Created by wangjianwei on 16/4/9.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTDropDownViewDetailCell.h"

@implementation MTDropDownViewDetailCell

+(instancetype)dropDownViewDetailCellWithTableView:(UITableView *)tableView
{
    static NSString *identifier =@"master_cell";
    MTDropDownViewDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MTDropDownViewDetailCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dropdown_rightpart"]];
        self.selectedBackgroundView = [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"bg_dropdown_right_selected"]];    }
    return self;
}

@end
