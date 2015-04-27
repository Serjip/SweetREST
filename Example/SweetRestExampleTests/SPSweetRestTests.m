//
//  SPSweetRestTests.m
//  SweetRestExample
//
//  Created by Sergey P on 22.03.15.
//  Copyright (c) 2015 Sergey Popov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SPSweetRest.h"

@interface SPSweetRestTests : XCTestCase

@property (nonatomic, strong, readonly) SPSweetRest *sweetRest;

@end

@implementation SPSweetRestTests

- (void)setUp
{
    [super setUp];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    _sweetRest = [[SPSweetRest alloc] initWithSession:session baseURL:[NSURL URLWithString:@"http://localhost:8080/"]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testPOST
{
    XCTestExpectation *ex = [self expectationWithDescription:@"Response"];
    
    [self.sweetRest POST:@"test" params:@{@"field":@"one"} completion:^(id responseObject, NSError *error) {
        
        NSLog(@"%@",responseObject);
        XCTAssertNil(error);
        
        [ex fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30.f handler:nil];
}

@end
