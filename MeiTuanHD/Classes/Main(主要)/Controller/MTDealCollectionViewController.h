//
//  MTDealCollectionViewController.h
//  MTHD
//
//  Created by wangjianwei on 16/4/13.
//  Copyright © 2016年 JW. All rights reserved.
//  专门用来负责请求从服务器中获取数据的父类

#import <UIKit/UIKit.h>
#import "MTBaseDealCollectionViewController.h"
@interface MTDealCollectionViewController : MTBaseDealCollectionViewController
/**父类供子类调用的方法*/
-(void)setupParams:(NSMutableDictionary *)params;
@end
