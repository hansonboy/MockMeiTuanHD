//
//  MTHttpTool.h
//  MTHD
//
//  Created by wangjianwei on 16/4/22.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^success)(id result);
typedef void(^failure)(NSError *error);

@interface MTHttpTool : NSObject

+(MTHttpTool *)sharedHttpTool;

- (void)requestWithURL:(NSString *)url params:(NSMutableDictionary *)params success:(success)success failure:(failure)failure;

@end
