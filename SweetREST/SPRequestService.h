//
//  SPRequestService.h
//  APIHelper
//
//  Created by Sergey Popov on 11.03.15.
//  Copyright (c) 2015 Sergey Popov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;

typedef void (^SPRequestServiceCallback)(NSURLSessionDataTask *task, id responseObject, NSError *error);
typedef void (^SWCallbak);

@interface SPRequestService : NSObject

@property (strong, nonatomic, readonly) AFHTTPSessionManager *sessionManager;

- (instancetype)initWithSessionManager:(AFHTTPSessionManager *)manger;
- (void)GET:(NSString *)URLString params:(id)params completion:(SPRequestServiceCallback)callback;

@end
