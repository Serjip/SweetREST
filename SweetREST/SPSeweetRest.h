//
//  SRService.h
//  SweetRest
//
//  Created by Sergey Popov on 13.03.15.
//  Copyright (c) 2015 Sergey Popov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPSeweetRest : NSObject

@property (strong, nonatomic) NSURL *baseURL;
@property (assign, nonatomic) NSStringEncoding stringEncoding;
@property (copy, nonatomic) NSIndexSet *acceptableStatusCodes;
@property (strong, nonatomic, readonly) NSURLSession *session;
@property (nonatomic, strong) NSSet *acceptableContentTypes;
@property (nonatomic, assign) NSJSONReadingOptions readingOptions;
@property (readonly, nonatomic, strong) NSDictionary *HTTPRequestHeaders;

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
@end


extern NSString * const SPSeweetRestErrorDomain;
