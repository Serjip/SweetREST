//
//  SPRequestService.m
//  APIHelper
//
//  Created by Sergey Popov on 11.03.15.
//  Copyright (c) 2015 Sergey Popov. All rights reserved.
//

#import "SPRequestService.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@interface SPRequestService ()

@property (nonatomic, copy) void(^failureBlock)(NSURLSessionDataTask *task, NSError *error);
@property (nonatomic, copy) void(^successBlock)(NSURLSessionDataTask *task, id responseObject);

@end

@implementation SPRequestService

#pragma mark - init

- (instancetype)initWithSessionManager:(AFHTTPSessionManager *)manger
{
    self = [super init];
    if (self)
    {
        _sessionManager = manger;
    }
    return self;
}

#pragma mark - Public Instance

- (void)GET:(NSString *)URLString params:(id)params completion:(SPRequestServiceCallback)callback
{
    [self.sessionManager GET:URLString parameters:params success:[self sp_successProccessing] failure:[self sp_failureProccessing]];
}

#pragma mark - Private Instance

- (void (^)(NSURLSessionDataTask *task, NSError *error))sp_failureProccessing
{
    return ^(NSURLSessionDataTask *task, NSError *error) {
        
        if (self.failureBlock)
        {
            self.failureBlock(task, error);
        }
    };
}

- (void (^)(NSURLSessionDataTask *task, id responseObject))sp_successProccessing
{
    return ^(NSURLSessionDataTask *task, id responseObject) {
      
        if (self.successBlock)
        {
            self.successBlock(task, responseObject);
        }
        
    };
}

@end
