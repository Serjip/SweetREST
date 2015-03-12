//
//  SPRequestService.h
//  SweetRest
//
//  Created by Sergey Popov on 11.03.15.
//  Copyright (c) 2015 Sergey Popov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;

typedef void (^SRPerform)(NSURLSessionDataTask *task, id responseObject);
typedef void (^SRComplete)(NSURLSessionDataTask *task, NSError *error);

@interface SPRequestService : NSObject

@property (strong, nonatomic, readonly) AFHTTPSessionManager *sessionManager;

- (instancetype)initWithSessionManager:(AFHTTPSessionManager *)manger;
- (instancetype)initWithSessionManager:(AFHTTPSessionManager *)manger
                               success:(NSError *(^)(NSURLSessionDataTask *, id responseObj))success
                               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)GET:(NSString *)URLString params:(id)params perform:(SRPerform)perform complete:(SRComplete)complete;
- (void)POST:(NSString *)URLString params:(id)params perform:(SRPerform)perform complete:(SRComplete)complete;
- (void)PUT:(NSString *)URLString params:(id)params perform:(SRPerform)perform complete:(SRComplete)complete;
- (void)PATCH:(NSString *)URLString params:(id)params perform:(SRPerform)perform complete:(SRComplete)complete;
- (void)DELETE:(NSString *)URLString params:(id)params perform:(SRPerform)perform complete:(SRComplete)complete;

@end

extern NSString * const SRErrorDomain;
