//
//  MTHomeController.m
//  MeiTuanHD
//
//  Created by wangjianwei on 16/3/28.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTHomeController.h"
@interface MTHomeController()

@end
@implementation MTHomeController
-(instancetype)init{
    if (self = [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]]) {
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
    }
    return  self;
}
@end
