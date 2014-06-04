//
//  NSObject+KeyValueMapping.m
//  KMAssistant
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

#import <objc/runtime.h>

#import "NSObject+KeyValueMapping.h"

@implementation NSObject (KeyValueMapping)

#pragma mark -
- (void)mergeDictionary:(NSDictionary *)dictionary {
    [self mergeDictionary:dictionary
         withMappingBlock:nil
withCollectionMappingBlock:nil];
}

- (void)mergeDictionary:(NSDictionary *)dictionary
       withMappingBlock:(MappingBlock)customMappingBlock {
    [self mergeDictionary:dictionary
         withMappingBlock:customMappingBlock
withCollectionMappingBlock:nil];
}

- (void)mergeDictionary:(NSDictionary *)dictionary
withCollectionMappingBlock:(CollectionMappingBlock)customCollectionMappingBlock {
    [self mergeDictionary:dictionary
         withMappingBlock:nil
withCollectionMappingBlock:customCollectionMappingBlock];
    
}

- (void)mergeDictionary:(NSDictionary *)dictionary
       withMappingBlock:(MappingBlock)customMappingBlock
withCollectionMappingBlock:(CollectionMappingBlock)customCollectionMappingBlock {
    [self merge:dictionary
        forKeys:[dictionary allKeys]
withMappingBlock:customMappingBlock
withCollectionMappingBlock:customCollectionMappingBlock];
}

- (void)merge:(NSObject *)sourceObject
      forKeys:(NSArray *)keys
withMappingBlock:(MappingBlock)customMappingBloc
withCollectionMappingBlock:(CollectionMappingBlock)customCollectionMappingBlock {
    for (NSString *key in keys) {
        id object = [sourceObject valueForKey:key];
        objc_property_t theProperty = class_getProperty([self class], [key UTF8String]);
        
        if (theProperty) {
            if ((!customMappingBloc)
                || (!customMappingBloc(self, object, key))) {
                if (([object isKindOfClass:[NSArray class]])
                    && (customCollectionMappingBlock)) {
                    for (int index = 0; index < ((NSArray *)object).count; ++index) {
                        customCollectionMappingBlock(self, object[index], key, index);
                    }
                } else {
                    if ([self isProperty:theProperty aClassWithName:@"NSSet"]) {
                        if ([object isKindOfClass:[NSArray class]]) {
                            [self setValue:[NSSet setWithArray:object]
                                    forKey:key];
                        } else if ([object isKindOfClass:[NSOrderedSet class]]) {
                            [self setValue:[NSSet setWithArray:[object allObjects]]
                                    forKey:key];
                        } else if ([object isKindOfClass:[NSSet class]]) {
                            [self setValue:object
                                    forKey:key];
                        }
                    } else if ([self isProperty:theProperty aClassWithName:@"NSOrderedSet"])
                    {
                        if ([object isKindOfClass:[NSArray class]]) {
                            [self setValue:[NSOrderedSet orderedSetWithArray:object]
                                    forKey:key];
                        } else if ([object isKindOfClass:[NSOrderedSet class]]) {
                            [self setValue:object
                                    forKey:key];
                        }
                    } else {
                        [self setValue:object
                                forKey:key];
                    }
                }
            }
        }
    }
}

- (BOOL)isProperty:(objc_property_t)property aClassWithName:(NSString *)className {
    NSString *propertyAttributes = [[NSString alloc] initWithUTF8String:property_getAttributes(property)];
    
    return [propertyAttributes rangeOfString:className].location != NSNotFound;
}

@end
