//
//  SPRequestService.m
//  SweetRest
//
//  Created by Sergey Popov on 11.03.15.
//  Copyright (c) 2015 Sergey Popov. All rights reserved.
//

#import "SPRequestService.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@interface SPRequestService ()

@property (nonatomic, copy) void(^failureBlock)(NSURLSessionDataTask *task, NSError *error);
@property (nonatomic, copy) NSError *(^successBlock)(NSURLSessionDataTask *task, id responseObject);
@property (nonatomic, strong, readonly) NSOperationQueue *performQueue;

@end

@implementation SPRequestService

#pragma mark - init

- (instancetype)init
{
    NSAssert(NO, @"Please do not use init.");
    return nil;
}

- (instancetype)initWithSessionManager:(AFHTTPSessionManager *)manger
{
    self = [super init];
    if (self)
    {
        _sessionManager = manger;
        _performQueue = [NSOperationQueue new];
    }
    return self;
}

- (instancetype)initWithSessionManager:(AFHTTPSessionManager *)manger success:(NSError *(^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    self = [self initWithSessionManager:manger];
    
    if (self)
    {
        _successBlock = success;
        _failureBlock = failure;
    }
    return self;
}

#pragma mark - Public Instance

- (void)GET:(NSString *)URLString params:(id)params perform:(SRPerform)perform complete:(SRComplete)complete
{
    NSParameterAssert(perform);
    NSParameterAssert(complete);
    
    [self.sessionManager GET:URLString parameters:params
                     success:[self sr_successWithPerform:perform complete:complete]
                     failure:[self sr_failureWithComplete:complete]];
}

- (void)POST:(NSString *)URLString params:(id)params perform:(SRPerform)perform complete:(SRComplete)complete
{
    NSParameterAssert(perform);
    NSParameterAssert(complete);
    
    [self.sessionManager POST:URLString parameters:params
                      success:[self sr_successWithPerform:perform complete:complete]
                      failure:[self sr_failureWithComplete:complete]];
}

- (void)PUT:(NSString *)URLString params:(id)params perform:(SRPerform)perform complete:(SRComplete)complete
{
    NSParameterAssert(perform);
    NSParameterAssert(complete);
    
    [self.sessionManager PUT:URLString parameters:params
                     success:[self sr_successWithPerform:perform complete:complete]
                     failure:[self sr_failureWithComplete:complete]];
}


- (void)PATCH:(NSString *)URLString params:(id)params perform:(SRPerform)perform complete:(SRComplete)complete
{
    NSParameterAssert(perform);
    NSParameterAssert(complete);
    
    [self.sessionManager PATCH:URLString parameters:params
                       success:[self sr_successWithPerform:perform complete:complete]
                       failure:[self sr_failureWithComplete:complete]];
}

- (void)DELETE:(NSString *)URLString params:(id)params perform:(SRPerform)perform complete:(SRComplete)complete
{
    NSParameterAssert(perform);
    NSParameterAssert(complete);
    
    [self.sessionManager DELETE:URLString parameters:params
                        success:[self sr_successWithPerform:perform complete:complete]
                        failure:[self sr_failureWithComplete:complete]];
}

#pragma mark - Private Instance

- (void (^)(NSURLSessionDataTask *task, id responseObject))sr_successWithPerform:(SRPerform)perform complete:(SRComplete)complete
{
    return ^(NSURLSessionDataTask *task, id responseObject) {
      
        NSError *err = nil;
        
        if (self.successBlock)
        {
            err = self.successBlock(task, responseObject);
        }
        
        if (err)
        {
            complete(task, err);
            return ;
        }
        
        @try {
            
            perform(task, responseObject);
            
        }
        @catch (NSException *exception) {
            
            err = [NSError errorWithDomain:SRErrorDomain code:100 userInfo:@{NSLocalizedDescriptionKey : exception.reason}];
            
        }
        
        complete(task, err);
        
    };
}

- (void (^)(NSURLSessionDataTask *task, NSError *error))sr_failureWithComplete:(SRComplete)complete
{
    return ^(NSURLSessionDataTask *task, NSError *error) {
        
        if (self.failureBlock)
        {
            self.failureBlock(task, error);
        }
        
        complete(task, error);
    };
}

@end

NSString * const SRErrorDomain = @"SRErrorDomain";
