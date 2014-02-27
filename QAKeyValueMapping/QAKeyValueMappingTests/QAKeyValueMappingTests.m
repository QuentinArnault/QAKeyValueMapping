//
//  QAKeyValueMappingTests.m
//  QAKeyValueMappingTests
//
//  Created by Quentin Arnault on 27/02/2014.
//  Copyright (c) 2014 Quentin Arnault. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
//  persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
//  Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.//

#import <XCTest/XCTest.h>

#import "NSObject+KeyValueMapping.h"

@interface QATestObject : NSObject

@property (nonatomic, strong) NSSet *set;
@property (nonatomic, strong) NSOrderedSet *orderedSet;

@end

@implementation QATestObject
@end

@interface QAKeyValueMappingTests : XCTestCase

@end

@implementation QAKeyValueMappingTests

#pragma mark - test suite
- (void)test_should_merge_array_into_set {
    // ARRANGE
    NSDictionary *dictWithArray = @{@"set": @[@"firstElement", @"secondElement"]};
    QATestObject *testObject = [[QATestObject alloc] init];

    // ACT
    [testObject mergeDictionary:dictWithArray];
    
    // ASSERT
    XCTAssertTrue([testObject.set
                   isKindOfClass:[NSSet class]]
                          , @"should have created a set");
    XCTAssertEqual((NSUInteger)2
                   , testObject.set.count
                   , @"should have merged two elements of array");
}

- (void)test_should_merge_array_into_ordered_set {
    // ARRANGE
    NSDictionary *dictWithArray = @{@"orderedSet": @[@"firstElement", @"secondElement"]};
    QATestObject *testObject = [[QATestObject alloc] init];
    
    // ACT
    [testObject mergeDictionary:dictWithArray];
    
    // ASSERT
    XCTAssertTrue([testObject.orderedSet
                   isKindOfClass:[NSOrderedSet class]]
                  , @"should have created an ordered set");
    XCTAssertEqual((NSUInteger)2
                   , testObject.orderedSet.count
                   , @"should have merged two elements of array");
}


@end
