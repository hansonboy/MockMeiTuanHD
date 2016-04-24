//
//  MTHttpToolTest.m
//  MTHD
//
//  Created by wangjianwei on 16/4/24.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MTHttpTool.h"
@interface MTHttpToolTest : XCTestCase

@property (nonatomic, strong)MTHttpTool *httpTool;

@end

@implementation MTHttpToolTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSingleleton {
    MTHttpTool *httptool = [MTHttpTool sharedHttpTool];
    MTHttpTool *ht = [MTHttpTool sharedHttpTool];
    XCTAssertEqualObjects(httptool, ht,@"不是单例模式");
}

//异步函数的单元测试
- (void)testHttpToolCanGetRequest
{
    
    //Expectation  用来实现主线程等待异步结果返回用的
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Method Works!"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"city"] = @"成都";
    params[@"region"] = @"锦江区";
    params[@"longitude"] = @(30.66);
    params[@"latitude"] = @(104.07);
    params[@"radius"] = @5000;
    NSDictionary __block *_result;
    NSError __block *_error;
    NSLog(@"%@",params);
    [[MTHttpTool sharedHttpTool] requestWithURL:@"v1/deal/find_deals" params:params success:^(id result) {
        _result = result;
        NSLog(@"%@",result);
        [expectation fulfill];
        XCTAssertNotNil(_result,@"%@",_result);
    } failure:^(NSError *error) {
        _error = error;
        XCTAssertNil(error);
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
        
    }];
    
    
}
- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
