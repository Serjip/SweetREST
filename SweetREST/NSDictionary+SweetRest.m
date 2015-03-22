//
//  NSDictionary+SweetRest.m
//  SweetRest
//
//  Created by Sergey Popov on 12.03.15.
//  Copyright (c) 2015 Sergey Popov. All rights reserved.
//

#import "NSDictionary+SweetRest.h"

@implementation NSDictionary (SweetRest)


- (BOOL)boolForKey:(id)key
{
    id object = [self objectForKey:key];
    
    if (object && ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) )
    {
        return [object boolValue];
    }
    
    [[NSException exceptionWithName:@"Unexpected data" reason:@"Expected bool" userInfo:nil] raise];
    
    return NO;
}

- (NSInteger)integerForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    if (obj && ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]))
    {
        return [obj integerValue];
    }
    
    [[NSException exceptionWithName:@"Unexpected data" reason:@"Expected integer" userInfo:nil] raise];
    
    return 0;
}

- (NSUInteger)unsignedIntegerForKey:(id)key
{
    return (NSUInteger)[self integerForKey:key];
}

- (NSDate *)dateForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    if (obj && ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]))
    {
        return [NSDate dateWithTimeIntervalSince1970:[obj doubleValue]];
    }
    
    [[NSException exceptionWithName:@"Unexpected data" reason:@"Expected date in unix format" userInfo:nil] raise];
    
    return nil;
}

- (NSString *)stringForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    if (obj && [obj isKindOfClass:[NSString class]])
    {
        return obj;
    }
    
    [[NSException exceptionWithName:@"Unexpected data" reason:@"Expected string" userInfo:nil] raise];
    
    return nil;
}

- (NSNumber *)numberForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    if (obj && [obj isKindOfClass:[NSNumber class]])
    {
        return obj;
    }
    return nil;
}

- (NSArray *)arrayForKey:(id)key
{
    id obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSArray class]])
    {
        return obj;
    }
    
    [[NSException exceptionWithName:@"Unexpected data" reason:@"Expected array" userInfo:nil] raise];
    
    return nil;
}

@end
