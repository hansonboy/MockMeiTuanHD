//
//  MTSearchResultTVC.h
//  MTHD
//
//  Created by wangjianwei on 16/4/10.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTSearchResultTVC : UITableViewController
/** 当中存放的是匹配城市在cities.plist 中的下标哦*/
@property (nonatomic ,strong)NSArray *result;
@end
