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

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSSet *set;
@property (nonatomic, strong) NSOrderedSet *orderedSet;
@property (nonatomic, strong) NSString *firstElement;
@property (nonatomic, strong) NSString *secondElement;

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

- (void)test_should_merge_set_into_set {
    // ARRANGE
    NSDictionary *dictWithArray = @{@"set": [NSSet setWithArray:@[@"firstElement", @"secondElement"]]};
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

- (void)test_should_merge_ordered_set_into_set {
    // ARRANGE
    NSDictionary *dictWithArray = @{@"set": [NSOrderedSet orderedSetWithArray:@[@"firstElement", @"secondElement"]]};
    QATestObject *testObject = [[QATestObject alloc] init];
    
    // ACT
    [testObject mergeDictionary:dictWithArray];
    
    // ASSERT
    XCTAssertTrue([testObject.set
                   isKindOfClass:[NSSet class]]
                  , @"should have created an ordered set");
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

- (void)test_should_merge_ordered_set_into_ordered_set {
    // ARRANGE
    NSDictionary *dictWithArray = @{@"orderedSet": [NSOrderedSet orderedSetWithArray:@[@"firstElement", @"secondElement"]]};
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

- (void)test_should_merge_array_into_array {
    // ARRANGE
    NSDictionary *dictWithArray = @{@"array": @[@"firstElement", @"secondElement"]};
    QATestObject *testObject = [[QATestObject alloc] init];
    
    // ACT
    [testObject mergeDictionary:dictWithArray];
    
    // ASSERT
    XCTAssertTrue([testObject.array
                   isKindOfClass:[NSArray class]]
                  , @"should have created an array");
    XCTAssertEqual((NSUInteger)2
                   , testObject.array.count
                   , @"should have merged two elements of array");
}

- (void)test_should_call_mapping_block_for_keys {
    // ARRANGE
    NSDictionary *dictWithTwoElements = @{@"firstElement": @"aValue"
                                          , @"secondElement": @"anotherValue"};
    QATestObject *testObject = [[QATestObject alloc] init];
    
    // ACT
    __block int callCount = 0;
    [testObject mergeDictionary:dictWithTwoElements
               withMappingBlock:^BOOL(NSObject *target, NSObject *source, NSString *key) {
                   ++callCount;
                   
                   return NO;
               }];
    
    // ASSERT
    XCTAssertEqual([dictWithTwoElements allKeys].count
                   , callCount
                   , @"should have call mapping block twice");
}

- (void)test_should_call_mapping_block_for_collection_items {
    // ARRANGE
    NSDictionary *dictWithArray = @{@"array": @[@"firstElement", @"secondElement"]};
    QATestObject *testObject = [[QATestObject alloc] init];
    
    // ACT
    __block int callCount = 0;
    [testObject mergeDictionary:dictWithArray
     withCollectionMappingBlock:^BOOL(NSObject *target, NSObject *source, NSString *key, int index) {
         ++callCount;
         
         return NO;
     }];
    
    // ASSERT
    XCTAssertEqual(2
                   , callCount
                   , @"should have call mapping block twice");
}

- (void)test_should_call_mapping_block_for_collection_items_and_other_items {
    // ARRANGE
    NSDictionary *dictWithArray = @{@"array": @[@"firstElement", @"secondElement"]
                                    , @"firstElement": @"aValue"};
    QATestObject *testObject = [[QATestObject alloc] init];
    
    // ACT
    __block int callCount = 0;
    __block int callCollectionCount = 0;
    [testObject mergeDictionary:dictWithArray
               withMappingBlock:^BOOL(NSObject *target, NSObject *source, NSString *key) {
                   ++callCount;
                   
                   return NO;
               }
     withCollectionMappingBlock:^BOOL(NSObject *target, NSObject *source, NSString *key, int index) {
         ++callCollectionCount;
         
         return NO;
     }];
    
    // ASSERT
    XCTAssertEqual(2
                   , callCount
                   , @"should have call mapping block");
    XCTAssertEqual(2
                   , callCount
                   , @"should have call collection mapping block twice");
}

- (void)test_should_ignore_keys_not_present_in_source_object {
    // ARRANGE
    NSDictionary *dictWithNotPresentKey = @{@"keyFromNowhere": @"aValue"};
    
    QATestObject *testObject = [[QATestObject alloc] init];
    
    // ACT
    [testObject mergeDictionary:dictWithNotPresentKey];
    
    // ASSERT
    // should not have crashed
}

@end
