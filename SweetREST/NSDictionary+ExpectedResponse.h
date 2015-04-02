//
//  NSDictionary+ExpectedResponse.h
//  SweetRest
//
//  Created by Sergey Popov on 12.03.15.
//  Copyright (c) 2015 Sergey Popov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ExpectedResponse)

- (BOOL)expectedBoolForKey:(id)key;
- (double)expectedDoubleForKey:(id)key;
- (NSInteger)expectedIntegerForKey:(id)key;
- (NSUInteger)expectedUnsignedIntegerForKey:(id)key;

- (NSDate *)expectedDateForKey:(id)key;
- (NSArray *)expectedArrayForKey:(id)key;
- (NSString *)expectedStringForKey:(id)key;
- (NSNumber *)expectedNumberForKey:(id)key;
- (NSDictionary *)expectedDictionaryForKey:(id)key;

@end
