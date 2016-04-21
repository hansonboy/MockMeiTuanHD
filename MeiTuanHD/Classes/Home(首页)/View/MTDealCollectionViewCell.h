//
//  MTDealCollectionViewCell.h
//  MTHD
//
//  Created by wangjianwei on 16/4/12.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTDealCollectionViewCell;
@protocol MTDealCollectionViewCellDelegate<NSObject>
@optional
- (void)dealCollectionViewCellDidSelectOrNot:(MTDealCollectionViewCell *)cell;
@end
@class MTDeal;
@interface MTDealCollectionViewCell : UICollectionViewCell

@property (nonatomic ,assign)id<MTDealCollectionViewCellDelegate> delegate;
@property (nonatomic ,strong)MTDeal *deal;

@end
