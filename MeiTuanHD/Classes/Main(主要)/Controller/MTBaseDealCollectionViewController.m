//
//  MTBaseDealCollectionViewController.m
//  MTHD
//
//  Created by wangjianwei on 16/4/21.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTBaseDealCollectionViewController.h"
#import "MTDealCollectionViewCell.h"
#import "MTDetailDealViewController.h"
#import "MJExtension.h"
#import "Masonry.h"

@interface MTBaseDealCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation MTBaseDealCollectionViewController

static NSString *const identificer = @"MTDealCollectionViewCell";

- (NSMutableArray *)deals {
    if (_deals == nil) {
        _deals = [NSMutableArray array];
    }
    return _deals;
}
#pragma mark - noDataView 设置
- (UIImageView *)noDataView
{
    if (_noDataView == nil) {
        _noDataView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_deals_empty"]];
        [self.collectionView addSubview:_noDataView];
        _noDataView.hidden = YES;
        [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.collectionView.mas_centerX);
            make.centerY.equalTo(self.collectionView.mas_centerY);
        }];
    }
    return _noDataView;
}
#pragma mark - 初始化
- (instancetype)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(300, 300);
    if (self = [super initWithCollectionViewLayout:flowLayout]) {
        self.collectionView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"MTDealCollectionViewCell" bundle:[NSBundle mainBundle]]forCellWithReuseIdentifier:identificer];
        self.collectionView.alwaysBounceVertical = YES;
        
    }
    return self;
}

#pragma mark - 设置横竖屏下的间距
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    int columns = 2;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    if(size.width == 1024.0) //横屏状态
    {
        columns = 3;
    }
    CGFloat HM = (size.width - columns*flowLayout.itemSize.width)/(columns+1);
    flowLayout.minimumLineSpacing = HM;
    flowLayout.sectionInset = UIEdgeInsetsMake(HM, HM, HM, HM);
    self.collectionView.collectionViewLayout = flowLayout;
}

#pragma mark - UICollectionViewController data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //设置第一次加载的间距
    [self viewWillTransitionToSize:CGSizeMake(self.collectionView.frame.size.width, 0) withTransitionCoordinator:nil];
    
    return self.deals.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.noDataView.hidden = YES;
    MTDealCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identificer forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MTDealCollectionViewCell alloc]init];
    }
    cell.deal = [self.deals objectAtIndex:indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewController delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MTDetailDealViewController *detailController = [[MTDetailDealViewController alloc]init];
    //必须得先调用view,否则下面的句子将会无效
    //    [detailController loadView];
    detailController.deal = [self.deals objectAtIndex:indexPath.item];
    [self presentViewController:detailController animated:YES completion:nil];
}
@end
