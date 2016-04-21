//
//  MTCollectViewController.m
//  MTHD
//
//  Created by wangjianwei on 16/4/21.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTCollectViewController.h"
#import "MTCollectDealTool.h"
#import "UIView+Extension.h"
#import "UIBarButtonItem+Extension.h"
#import "MJRefresh.h"
#import "MTDealCollectionViewCell.h"
@interface MTCollectViewController ()<MTDealCollectionViewCellDelegate>

@property(nonatomic, strong) UIBarButtonItem *selectAllItem;
@property(nonatomic, strong) UIBarButtonItem *unselectAllItem;
@property(nonatomic, strong) UIBarButtonItem *deleteItem;
@property(nonatomic, strong) UIBarButtonItem *backItem;
@property(nonatomic, assign) NSInteger currentPage;
@end
static const CGFloat kMTBarItemWidth = 100;
@implementation MTCollectViewController
+(void)initialize
{
    if (self == [MTCollectViewController self]) {
        UIBarButtonItem  *naviItem = [UIBarButtonItem appearance];
        naviItem.tintColor = MTColor(21, 188, 173);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    [self setupLeftGoBackBarItem];
    [self setupRightBarItem];
    
    
    self.collectionView.mj_footer =  [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [MTCollectDealTool test];
    [self.collectionView.mj_footer beginRefreshing];
    
}
- (void)loadMore {
    self.currentPage ++;
    NSArray *result = [MTCollectDealTool loadDealsByPage:self.currentPage];
    if (result) {
        [self.collectionView.mj_footer endRefreshing];
        [self.deals addObjectsFromArray:result];
        [self.collectionView reloadData];
    }
    else
    {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
    
}
#pragma mark - 初始化Item
- (void)setupRightBarItem {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)setupLeftGoBackBarItem{
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem = self.backItem;
}
- (void)setupLeftBarItems {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = @[self.backItem,self.selectAllItem,self.unselectAllItem,self.deleteItem];
}
-(UIBarButtonItem *)backItem
{
    if (_backItem == nil) {
        _backItem = [UIBarButtonItem itemWithTarget:self action:@selector(goBack) imageName:@"icon_back" selecteImageName:@"icon_back_highlighted"];
    }
    return _backItem;
}
-(UIBarButtonItem *)selectAllItem
{
    if (_selectAllItem == nil) {
        _selectAllItem = [[UIBarButtonItem alloc]initWithTitle:@"全选" style:UIBarButtonItemStyleDone target:self action:@selector(selectAll)];
        _selectAllItem.width = kMTBarItemWidth;
    }
    return _selectAllItem;
}
-(UIBarButtonItem *)unselectAllItem
{
    if (_unselectAllItem== nil) {
        _unselectAllItem = [[UIBarButtonItem alloc]initWithTitle:@"全不选" style:UIBarButtonItemStyleDone target:self action:@selector(unselectAll)];
        _unselectAllItem.width = kMTBarItemWidth;
    }
    return _unselectAllItem;
}

-(UIBarButtonItem *)deleteItem
{
    if (_deleteItem == nil) {
        _deleteItem =[[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(delete)];
        _selectAllItem.width = kMTBarItemWidth;
    }
    _deleteItem.enabled = NO;
    return _deleteItem;
}


#pragma mark - 响应导航栏方法
- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectAll
{
    for (MTDeal *deal in self.deals) {
        deal.selected = YES;
    }
    [self.collectionView reloadData];
    self.deleteItem.enabled = YES;
}

- (void)unselectAll {
    for (MTDeal *deal in self.deals) {
        deal.selected = NO;
    }
    [self.collectionView reloadData];
    self.deleteItem.enabled = NO;
}
- (void)delete
{
    NSMutableArray *toDeleteDeals = [NSMutableArray array];
    for (MTDeal *deal in self.deals) {
        if(deal.selected)
        {
            [toDeleteDeals addObject:deal];
            //删除本地数据库中的数据
            [MTCollectDealTool removeDeal:deal];
        }
    }
    //删除内存中的数据
    [self.deals removeObjectsInArray:toDeleteDeals];
    [self.collectionView reloadData];
    
    //因为灭有选中的item，所以删除按钮暂时不可以用
    self.deleteItem.enabled = NO;

}
- (void)edit:(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:@"编辑"]) {
        [item setTitle:@"完成"];
        for (MTDeal *deal in self.deals) {
            deal.editing = YES;
        }
        [self.collectionView reloadData];
        
        [self setupLeftBarItems];
    }
    else
    {
        [self setupLeftGoBackBarItem];
        [item setTitle:@"编辑"];
        for (MTDeal *deal in self.deals) {
            deal.editing = NO;
        }
        [self.collectionView reloadData];
    }
}
#pragma mark - CollectionView Delegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MTDealCollectionViewCell * cell = (MTDealCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}
#pragma mark - MTDealCollectionViewCellDelegate
-(void)dealCollectionViewCellDidSelectOrNot:(MTDealCollectionViewCell *)cell
{
    [self judgeIsDeleted];
}

//判断是否是可以删除的
- (void)judgeIsDeleted {
    BOOL hasSelected = NO;
    for (MTDeal *deal in self.deals) {
        if (deal.selected) {
            hasSelected = YES;
        }
    }
    self.deleteItem.enabled = hasSelected;
}
@end
