//
//  SRService.h
//  SweetRest
//
//  Created by Sergey Popov on 13.03.15.
//  Copyright (c) 2015 Sergey Popov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SPSeweetRestDelegate;
@interface SPSeweetRest : NSObject

@property (nonatomic, strong, readonly) NSURL *baseURL;
@property (nonatomic, strong, readonly) NSURLSession *session;
@property (nonatomic, strong, readonly) NSDictionary *HTTPRequestHeaders;
@property (nonatomic, strong, readwrite) NSSet *acceptableContentTypes;
@property (nonatomic, copy, readwrite) NSIndexSet *acceptableStatusCodes;

@property (nonatomic, assign) NSStringEncoding stringEncoding;
@property (nonatomic, assign) NSJSONReadingOptions readingOptions;
@property (nonatomic, weak) id<SPSeweetRestDelegate> delegate;

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
- (void)removeValueForHTTPHeaderField:(NSString *)field;
- (NSString *)valueForHTTPHeaderField:(NSString *)field;

- (instancetype)initWithSession:(NSURLSession *)session baseURL:(NSURL *)url;

- (NSURLSessionDataTask *)GET:(NSString *)URLString params:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion;
- (NSURLSessionDataTask *)PUT:(NSString *)URLString params:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion;
- (NSURLSessionDataTask *)HEAD:(NSString *)URLString params:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion;
- (NSURLSessionDataTask *)POST:(NSString *)URLString params:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion;
- (NSURLSessionDataTask *)PATCH:(NSString *)URLString params:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion;
- (NSURLSessionDataTask *)DELETE:(NSString *)URLString params:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion;

@end

@protocol SPSeweetRestDelegate <NSObject>

@optional
- (void)sweetRest:(SPSeweetRest *)sweetRest didReceiveResponse:(NSHTTPURLResponse *)response;
- (void)sweetRest:(SPSeweetRest *)sweetRest response:(NSHTTPURLResponse *)response didFailure:(NSError *)error;
- (BOOL)sweetRest:(SPSeweetRest *)sweetRest shouldAcceptResponse:(NSHTTPURLResponse *)response error:(NSError **)error;

@end

extern NSString * const SPSeweetRestErrorDomain;
