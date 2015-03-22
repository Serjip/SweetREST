//
//  NSDictionary+SweetRest.h
//  SweetRest
//
//  Created by Sergey Popov on 12.03.15.
//  Copyright (c) 2015 Sergey Popov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SweetRest)

- (BOOL)boolForKey:(id)key;
- (double)doubleForKey:(id)key;
- (NSInteger)integerForKey:(id)key;
- (NSUInteger)unsignedIntegerForKey:(id)key;

- (NSDate *)dateForKey:(id)key;
- (NSArray *)arrayForKey:(id)key;
- (NSString *)stringForKey:(id)key;
- (NSNumber *)numberForKey:(id)key;
- (NSDictionary *)dictionaryForKey:(id)key;

@end
