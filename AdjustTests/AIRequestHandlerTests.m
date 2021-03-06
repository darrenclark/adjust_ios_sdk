//
//  ADJRequestHandlerTests.m
//  Adjust
//
//  Created by Pedro Filipe on 07/02/14.
//  Copyright (c) 2014 adjust GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ADJAdjustFactory.h"
#import "ADJLoggerMock.h"
#import "NSURLConnection+NSURLConnectionSynchronousLoadingMocking.h"
#import "ADJPackageHandlerMock.h"
#import "ADJRequestHandlerMock.h"
#import "ADJTestsUtil.h"

@interface ADJRequestHandlerTests : XCTestCase

@property (atomic,strong) ADJLoggerMock *loggerMock;
@property (atomic,strong) ADJPackageHandlerMock *packageHandlerMock;
@property (atomic,strong) id<ADJRequestHandler> requestHandler;


@end

@implementation ADJRequestHandlerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.

    [self reset];

}

- (void)tearDown
{
    [ADJAdjustFactory setLogger:nil];

    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)reset {
    self.loggerMock = [[ADJLoggerMock alloc] init];
    [ADJAdjustFactory setLogger:self.loggerMock];

    self.packageHandlerMock = [[ADJPackageHandlerMock alloc] init];
    self.requestHandler =[ADJAdjustFactory requestHandlerForPackageHandler:self.packageHandlerMock];
}

- (void)testSendPackage
{
    /*
    //  reseting to make the test order independent
    [self reset];

    //  set the connection to respond OK
    [NSURLConnection setConnectionError:NO];
    [NSURLConnection setResponseError:NO];

    [self.requestHandler sendPackage:[ADJTestsUtil buildEmptyPackage]];

    [NSThread sleepForTimeInterval:1.0];

    NSLog(@"%@", self.loggerMock);

    //  check the URL Connection was called
    XCTAssert([self.loggerMock containsMessage:ADJLogLevelTest beginsWith:@"NSURLConnection sendSynchronousRequest"],
              @"%@", self.loggerMock);

    //  check that the package handler was pinged after sending
    XCTAssert([self.loggerMock containsMessage:ADJLogLevelTest beginsWith:@"ADJPackageHandler finishedTrackingActivity"],
              @"%@", self.loggerMock);

    //  check the response data, the kind is unknown because is set by the package handler
    NSString *sresponseData= [NSString stringWithFormat:@"%@", self.packageHandlerMock.responseData];
    XCTAssert([sresponseData isEqualToString:@"[kind:unknown success:1 willRetry:0 error:(null) "
               "trackerToken:token trackerName:name network:network campaign:campaign adgroup:adgroup creative:creative]"],
                   @"%@", sresponseData);

    //  check that the package was successfully sent
    XCTAssert([self.loggerMock containsMessage:ADJLogLevelInfo beginsWith:@"Tracked session"],
              @"%@", self.loggerMock);

    //  check that the package handler was called to send the next package
    XCTAssert([self.loggerMock containsMessage:ADJLogLevelTest beginsWith:@"ADJPackageHandler sendNextPackage"], @"%@", self.loggerMock);
     */
}

- (void)testConnectionError {
    /*
    //  reseting to make the test order independent
    [self reset];

    //  set the connection to return error on the connection
    [NSURLConnection setConnectionError:YES];
    [NSURLConnection setResponseError:NO];

    [self.requestHandler sendPackage:[ADJTestsUtil buildEmptyPackage]];
    [NSThread sleepForTimeInterval:1.0];

    //  check the URL Connection was called
    XCTAssert([self.loggerMock containsMessage:ADJLogLevelTest beginsWith:@"NSURLConnection sendSynchronousRequest"],
              @"%@", self.loggerMock);

    //  check that the package handler was pinged after sending
    XCTAssert([self.loggerMock containsMessage:ADJLogLevelTest beginsWith:@"ADJPackageHandler finishedTrackingActivity"],
              @"%@", self.loggerMock);

    //  check the response data,
    NSString *sresponseData= [NSString stringWithFormat:@"%@", self.packageHandlerMock.responseData];
    XCTAssert([sresponseData isEqualToString:@"[kind:unknown success:0 willRetry:1 error:'connection error' "
               "trackerToken:(null) trackerName:(null) network:(null) campaign:(null) adgroup:(null) creative:(null)]"], @"%@", sresponseData);

    //  check that the package was successfully sent
    XCTAssert([self.loggerMock containsMessage:ADJLogLevelError beginsWith:@"Failed to track session. (connection error) Will retry later."],
              @"%@", self.loggerMock);

    //  check that the package handler was called to close the package to retry later
    XCTAssert([self.loggerMock containsMessage:ADJLogLevelTest beginsWith:@"ADJPackageHandler closeFirstPackage"],
              @"%@", self.loggerMock);
     */

}

- (void)testResponseError {
    /*
    //  reseting to make the test order independent
    [self reset];

    //  set the response to return an error
    [NSURLConnection setConnectionError:NO];
    [NSURLConnection setResponseError:YES];

    [self.requestHandler sendPackage:[ADJTestsUtil buildEmptyPackage]];
    [NSThread sleepForTimeInterval:1.0];

    //  check the URL Connection was called
    XCTAssert([self.loggerMock containsMessage:ADJLogLevelTest beginsWith:@"NSURLConnection sendSynchronousRequest"],
              @"%@", self.loggerMock);
    //  check that the package handler was pinged after sending
    XCTAssert([self.loggerMock containsMessage:ADJLogLevelTest beginsWith:@"ADJPackageHandler finishedTrackingActivity"],
              @"%@", self.loggerMock);

    //  check the response data,
    NSString *sresponseData= [NSString stringWithFormat:@"%@", self.packageHandlerMock.responseData];

    XCTAssert([sresponseData isEqualToString:@"[kind:unknown success:0 willRetry:0 error:'response error' "
               "trackerToken:(null) trackerName:(null) network:(null) campaign:(null) adgroup:(null) creative:(null)]"], @"%@", sresponseData);

    //  check that the package was successfully sent
    XCTAssert([self.loggerMock containsMessage:ADJLogLevelError beginsWith:@"Failed to track session. (response error)"],
              @"%@", sresponseData);

    //  check that the package handler was called to send the next package
    XCTAssert([self.loggerMock containsMessage:ADJLogLevelTest beginsWith:@"ADJPackageHandler sendNextPackage"],
              @"%@", self.loggerMock);
     */
}

@end
