

//
//  MTDealCollectionViewController.m
//  MTHD
//
//  Created by wangjianwei on 16/4/13.
//  Copyright © 2016年 JW. All rights reserved.
//

#import "MTDealCollectionViewController.h"
#import "DPAPI.h"
#import "MJRefresh.h"
#import "MTDeal.h"
#import "MTDealCollectionViewCell.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
@interface MTDealCollectionViewController ()<DPRequestDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
/** 最近的一次请求：出现多次请求冲突的时候，响应最近一次请求*/
@property (nonatomic ,strong)DPRequest  *recentRequest;
/** 当前的团购订单数组*/
@property (nonatomic ,strong)NSMutableArray *deals;
/** 当前页码*/
@property (nonatomic ,assign)NSInteger currentPage;
/** 总的订单数量*/
@property (nonatomic ,assign)NSInteger totalCount;
@end

@implementation MTDealCollectionViewController

static const NSInteger countPerPage = 40;
static NSString *const identificer = @"MTDealCollectionViewCell";

#pragma mark -初始化collectionView 及上拉刷新下拉刷新
-(instancetype)init{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(300, 300);
    if (self = [super initWithCollectionViewLayout:flowLayout]) {
        self.collectionView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"MTDealCollectionViewCell" bundle:[NSBundle mainBundle]]forCellWithReuseIdentifier:identificer];
        self.collectionView.alwaysBounceVertical = YES;
        
        
        self.collectionView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDeals)];
        self.collectionView.mj_footer =  [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
        self.collectionView.mj_footer.hidden = YES;
    }
    return  self;
}
- (NSMutableArray *)deals {
    if (_deals == nil) {
        _deals = [NSMutableArray array];
    }
    return _deals;
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



#pragma mark - 请求服务器的数据
- (void)loadDeals
{
    DPAPI *dp = [[DPAPI alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self setupParams:params];
        //单页限制
    params[@"limit"] = @(countPerPage);
    params[@"page"] = @(self.currentPage);
    self.recentRequest = [dp requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    JWLog(@"%@",params);
    
}
/** 获取新的请求订单，API参考大众点评：http://developer.dianping.com/app/api/v1/deal/find_deals*/
- (void)loadNewDeals {
    self.currentPage = 1;
    [self loadDeals];
}
- (void)loadMoreDeals
{
    self.currentPage ++;
    [self loadDeals];
}
#pragma mark - DP request delegate
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (error != nil) {
        JWLog(@"%@",error);
        [MBProgressHUD showError:@"请求的团购不存在" toView:self.view];
        [self.deals removeAllObjects];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        
        //返回的团购不存在，相当于返回一个空的数据
        [self request:self.recentRequest didFinishLoadingWithResult:nil];
        [self.collectionView.mj_footer endRefreshing];
        
    }
}
-(void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    //当不是最近的一次请求返回的时候，忽略该请求结果
    if(![self.recentRequest isEqual:request])return;
    if(self.currentPage == 1)
    {
        [self.collectionView.mj_header endRefreshing];
        [self.deals removeAllObjects];
        self.deals = [MTDeal mj_objectArrayWithKeyValuesArray:result[@"deals"]];
        if (self.deals.count == 0) {
            [MBProgressHUD showError:@"没有满足要求的团购" toView:self.view];
        }
        //如果不能够一行全部返回的话，那么就显示上拉刷新功能
        self.collectionView.mj_footer.hidden = countPerPage*self.currentPage > [result[@"total_count"] integerValue];
    }
    else
    {
        [self.collectionView.mj_footer endRefreshing];
        //当前订单全部返回的时候，隐藏上拉刷新按钮
        if (countPerPage*self.currentPage >= [result[@"total_count"] integerValue]) {
            self.collectionView.mj_footer.hidden = YES;
        }
        [self.deals addObjectsFromArray:[MTDeal mj_objectArrayWithKeyValuesArray:result[@"deals"]]];
    }
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewController data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    [self viewWillTransitionToSize:CGSizeMake(self.collectionView.frame.size.width, 0) withTransitionCoordinator:nil];
    return self.deals.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MTDealCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identificer forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MTDealCollectionViewCell alloc]init];
    }
    cell.deal = [self.deals objectAtIndex:indexPath.item];
    return cell;
}



@end
