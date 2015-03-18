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
@property (strong, nonatomic, readonly) NSURLSession *session;
@property (assign, nonatomic) NSStringEncoding stringEncoding;
@property (copy, nonatomic) NSIndexSet *acceptableStatusCodes;
@property (nonatomic, strong) NSSet *acceptableContentTypes;
@property (nonatomic, assign) NSJSONReadingOptions readingOptions;

- (instancetype)initWithSession:(NSURLSession *)session baseURL:(NSURL *)url;

- (void)POST:(NSString *)URLString params:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion;

@end

@protocol SPSeweetRestDelegate <NSObject>

//- (void)sweetRest:(SPSeweetRest *)sr didReceiveResponse:(

@end


extern NSString * const SPSeweetRestErrorDomain;
