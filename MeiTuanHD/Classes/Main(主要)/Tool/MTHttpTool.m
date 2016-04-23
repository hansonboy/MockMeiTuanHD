//
//  MTHttpTool.m
//  MTHD
//
//  Created by wangjianwei on 16/4/22.
//  Copyright © 2016年 JW. All rights reserved.
//  封装DPAPI，同时实现将request 和 result error 进行绑定，方便我们实现请求之间互不干扰
//???: 我的单例模式是饿汉式的单例模式，懒汉式的单利模式好像有点问题，一会回来看看

#import "MTHttpTool.h"
#import "DPAPI.h"
@interface MTHttpTool()<DPRequestDelegate>

@property (nonatomic ,strong)DPAPI *dp;

@end

static MTHttpTool *sharedHttpTool;

@implementation MTHttpTool
- (DPAPI *)dp
{
    if (_dp == nil) {
        _dp = [[DPAPI alloc]init];
    }
    return _dp;
}
+(MTHttpTool *)sharedHttpTool{
        return sharedHttpTool;
}

+ (void)initialize
{
    if (self == [MTHttpTool class]) {
        sharedHttpTool = [[MTHttpTool alloc ]init];
    }
}
- (void)requestWithURL:(NSString *)url params:(NSMutableDictionary *)params success:(success)success failure:(failure)failure
{
    DPRequest *request = [self.dp requestWithURL:url params:params delegate:self];
    //通过在request中定义了一个success，failure来实现了一个request 和一个success ,failure进行的绑定
    request.success = success;
    request.failure = failure;
}

#pragma mark - dp request delegate
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (request.failure) {
        request.failure(error);
    }
}
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request.success) {
        request.success(result);
    }
}
@end
