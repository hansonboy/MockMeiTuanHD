//
//  MeiTuanHDTests.m
//  MeiTuanHDTests
//
//  Created by wangjianwei on 16/3/28.
//  Copyright © 2016年 JW. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MTMetaTool.h"
#import "MTCategory.h"
@interface MeiTuanHDTests : XCTestCase

@end

@implementation MeiTuanHDTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}
- (void)testMetaToolCategoryByName {
    MTCategory *category = [MTMetaTool categoryByName:@"美食"];
    XCTAssertTrue([category.map_icon isEqualToString:@"ic_category_1"]);
}
- (void)testStringIsEqual {
    NSString *str = [NSString stringWithFormat:@"is"];
    XCTAssertTrue([@"is" isEqualToString:str]);
    XCTAssertFalse([str isEqual:@"str"]);
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
