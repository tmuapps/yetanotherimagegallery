//
//  TMUImageDCTests.m
//  yetAnotherImageGallery
//
//  Created by tim millington on 12/03/2015.
//  Copyright (c) 2015 tmuApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OHHTTPStubs.h>
//#import <OHHTTPStubs/XCTestExpectation+OHRetroCompat.h>
#import "TMUImageDC.h"

@interface TMUImageDCTests : XCTestCase

@end

@implementation TMUImageDCTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // Remove  any existing Stubs
    [OHHTTPStubs removeAllStubs];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];

    // Remove  any existing Stubs
    [OHHTTPStubs removeAllStubs];

}

/*
+(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler;
*/
- (void)testDownloadDataFromURL {
    //TMUImageDC* imageDC = [[TMUImageDC alloc] init];

    NSString* dummyResponseString = @"{\"key\":\"value\"}";
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host isEqualToString:@"dummy.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // Stub the response with dummy json
        return [OHHTTPStubsResponse responseWithData:[dummyResponseString dataUsingEncoding:NSUTF8StringEncoding]
                                          statusCode:200
                                             headers:@{@"Content-Type":@"application/json"}];
    }];
    
    XCTestExpectation* dummyDataArrives = [self expectationWithDescription:@"Bytes from intercepted HTTP Request have arrived in NSData object"];
    
    __block NSData* receivedData;
    [TMUImageDC downloadDataFromURL:[NSURL URLWithString:@"https://dummy.com?withParm=0"] withCompletionHandler:^(NSData* responseData) {
        receivedData = responseData;
        [dummyDataArrives fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError* error){
        XCTAssertNotNil(receivedData, @"intercepted http request returned nil");
        NSString* receivedString = [NSString stringWithUTF8String:receivedData.bytes];
        XCTAssertNotNil(receivedString, @"bytes returned not converted to string");
        XCTAssertEqualObjects(receivedString, dummyResponseString, @"bytes returned not converted to string");
    }];
}
/*
- (void) getImageMetaDataArrayWithCompletionBlock: (void (^) (BOOL success)) imageListChangedHandler;
*/
- (void)testgetImageMetaDataArrayWithCompletionBlock {
    
    //Catch the HTTP requests to flickr feed
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.host isEqualToString:@"api.flickr.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // Stub the response with dummy json
        NSString* testflickrfeed1 = OHPathForFileInBundle(@"testflickrfeed1.json",nil);
        return [OHHTTPStubsResponse responseWithFileAtPath:testflickrfeed1
                                                statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
    
    //Set up the expectaion for aysynchrounsous get
    XCTestExpectation* imageMetaDataArrives = [self expectationWithDescription:@"JSON representation of image metadata arrives"];
    
    __block BOOL getWasSuccessful = NO;
    TMUImageDC* imageDC = [[TMUImageDC alloc] init];
    [imageDC getImageMetaDataArrayWithCompletionBlock: ^ (BOOL success) {
        getWasSuccessful = success;
        [imageMetaDataArrives fulfill];
    }];
    
    //When expecttaions are fulfilled, check the test conditions
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError* error){
        XCTAssert(getWasSuccessful, @"Get image metadata was not successful");
    }];
}


 /*
- (NSUInteger) countOfImages;
 */
/*
- (TMUImageWithDescriptor*) imageAtIndex:(NSUInteger) index;
 */


/*
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
*/
@end
