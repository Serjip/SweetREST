//
//  NSDictionary+ExpectedResponse.m
//  SweetRest
//
//  Created by Sergey Popov on 12.03.15.
//  Copyright (c) 2015 Sergey Popov. All rights reserved.
//

#import "NSDictionary+ExpectedResponse.h"

@implementation NSDictionary (ExpectedResponse)

- (BOOL)expectedBoolForKey:(id)key
{
    id object = [self objectForKey:key];
    
    if ( object && ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) )
    {
        return [object boolValue];
    }
    
    [[NSException exceptionWithName:@"Unexpected data" reason:@"Expected bool" userInfo:nil] raise];
    
    return NO;
}

- (double)expectedDoubleForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    if ( obj && ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) )
    {
        return [obj doubleValue];
    }
    
    [[NSException exceptionWithName:@"Unexpected data" reason:@"Expected date double" userInfo:nil] raise];
    
    return 0;
}

- (NSInteger)expectedIntegerForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    if ( obj && ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) )
    {
        return [obj integerValue];
    }
    
    [[NSException exceptionWithName:@"Unexpected data" reason:@"Expected integer" userInfo:nil] raise];
    
    return 0;
}

- (NSUInteger)expectedUnsignedIntegerForKey:(id)key
{
    return (NSUInteger)[self expectedIntegerForKey:key];
}

- (NSDate *)expectedDateForKey:(id)key
{
    return [NSDate dateWithTimeIntervalSince1970:[self expectedDoubleForKey:key]];
}

- (NSArray *)expectedArrayForKey:(id)key
{
    id obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSArray class]])
    {
        return obj;
    }
    else if ([obj isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    
    [[NSException exceptionWithName:@"Unexpected data" reason:@"Expected array" userInfo:nil] raise];
    
    return nil;
}

- (NSString *)expectedStringForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    if (obj && [obj isKindOfClass:[NSString class]])
    {
        return obj;
    }
    else if ([obj isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    
    [[NSException exceptionWithName:@"Unexpected data" reason:@"Expected string" userInfo:nil] raise];
    
    return nil;
}

- (NSNumber *)expectedNumberForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    if (obj && [obj isKindOfClass:[NSNumber class]])
    {
        return obj;
    }
    
    [[NSException exceptionWithName:@"Unexpected data" reason:@"Expected number" userInfo:nil] raise];
    
    return nil;
}

- (NSDictionary *)expectedDictionaryForKey:(id)key
{
    id obj = [self objectForKey:key];
    
    if (obj && [obj isKindOfClass:[NSDictionary class]])
    {
        return obj;
    }
    else if ([obj isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    
    [[NSException exceptionWithName:@"Unexpected data" reason:@"Expected dictionary" userInfo:nil] raise];
    
    return nil;
}

@end
