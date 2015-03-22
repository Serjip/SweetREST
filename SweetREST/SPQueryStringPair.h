//
//  SPQueryStringPair.h
//  SweetRest
//
//  Created by Sergey P on 22.03.15.
//  Copyright (c) 2015 Sergey Popov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPQueryStringPair : NSObject

@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

- (id)initWithField:(id)field value:(id)value;

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding;

+ (NSString *)queryStringWithParams:(NSDictionary *)params stringEncoding:(NSStringEncoding)encoding;

@end
