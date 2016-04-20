//
//  MTBaseDealCollectionViewController.h
//  MTHD
//
//  Created by wangjianwei on 16/4/21.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTBaseDealCollectionViewController : UICollectionViewController
/** 不含数据时候返回该dataView*/
@property (nonatomic ,strong)UIImageView *noDataView;
/** 当前的团购订单数组*/
@property (nonatomic ,strong)NSMutableArray *deals;
@end
