//
//  SPSweetRest.m
//  SweetRest
//
//  Created by Sergey Popov on 13.03.15.
//  Copyright (c) 2015 Sergey Popov. All rights reserved.
//

#import "SPSweetRest.h"
#import "SPQueryStringPair.h"

static dispatch_queue_t process_response_queue()
{
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("ttitt.sweetrest.process.response.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

@interface SPSweetRest ()

@property (nonatomic, strong, readonly) NSSet *HTTPMethodsEncodingParametersInURI;
@property (nonatomic, strong, readwrite) NSMutableDictionary *mutableHTTPRequestHeaders;

@end

@implementation SPSweetRest

#pragma mark - Properties

- (NSDictionary *)HTTPRequestHeaders
{
    return [NSDictionary dictionaryWithDictionary:self.mutableHTTPRequestHeaders];
}

#pragma mark - Public Instance

- (instancetype)initWithSession:(NSURLSession *)session baseURL:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        _baseURL = url;
        _session = session;
        _stringEncoding = NSUTF8StringEncoding;
        _readingOptions = NSJSONReadingMutableContainers;
        _acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
        _acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
        _mutableHTTPRequestHeaders = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"SweetRest",@"User-Agent",nil];
        _HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE", nil];
    }
    return self;
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    [self.mutableHTTPRequestHeaders setValue:value forKey:field];
}

- (void)removeValueForHTTPHeaderField:(NSString *)field
{
    [self.mutableHTTPRequestHeaders removeObjectForKey:field];
}

- (NSString *)valueForHTTPHeaderField:(NSString *)field
{
    return [self.mutableHTTPRequestHeaders valueForKey:field];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString params:(NSDictionary *)params completion:(void (^)(id jsonObject, NSError *error))completion
{
    return [self dataTaskWihtMethod:@"GET" URL:URLString params:params completion:completion];
}
- (NSURLSessionDataTask *)PUT:(NSString *)URLString params:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion
{
    return [self dataTaskWihtMethod:@"PUT" URL:URLString params:params completion:completion];
}
- (NSURLSessionDataTask *)HEAD:(NSString *)URLString params:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion
{
    return [self dataTaskWihtMethod:@"HEAD" URL:URLString params:params completion:completion];
}
- (NSURLSessionDataTask *)POST:(NSString *)URLString params:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion
{
    return [self dataTaskWihtMethod:@"POST" URL:URLString params:params completion:completion];
}
- (NSURLSessionDataTask *)PATCH:(NSString *)URLString params:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion
{
    return [self dataTaskWihtMethod:@"PATCH" URL:URLString params:params completion:completion];
}
- (NSURLSessionDataTask *)DELETE:(NSString *)URLString params:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion
{
    return [self dataTaskWihtMethod:@"DELETE" URL:URLString params:params completion:completion];
}

#pragma mark - Category ExpectedResponse

- (NSURLSessionDataTask *)GET:(NSString *)URLString params:(NSDictionary *)params
                          try:(void (^)(id))try completion:(void (^)(NSError *))completion
{
    return [self dataTaskWihtMethod:@"GET" URL:URLString params:params try:try completion:completion];
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString params:(NSDictionary *)params
                          try:(void (^)(id responseObject))try completion:(void (^)(NSError *error))completion
{
    return [self dataTaskWihtMethod:@"PUT" URL:URLString params:params try:try completion:completion];
}

- (NSURLSessionDataTask *)HEAD:(NSString *)URLString params:(NSDictionary *)params
                           try:(void (^)(id responseObject))try completion:(void (^)(NSError *error))completion
{
    return [self dataTaskWihtMethod:@"HEAD" URL:URLString params:params try:try completion:completion];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString params:(NSDictionary *)params
                           try:(void (^)(id responseObject))try completion:(void (^)(NSError *error))completion
{
    return [self dataTaskWihtMethod:@"POST" URL:URLString params:params try:try completion:completion];
}

- (NSURLSessionDataTask *)PATCH:(NSString *)URLString params:(NSDictionary *)params
                            try:(void (^)(id responseObject))try completion:(void (^)(NSError *error))completion
{
    return [self dataTaskWihtMethod:@"PATCH" URL:URLString params:params try:try completion:completion];
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString params:(NSDictionary *)params
                             try:(void (^)(id responseObject))try completion:(void (^)(NSError *error))completion
{
    return [self dataTaskWihtMethod:@"DELETE" URL:URLString params:params try:try completion:completion];
}

#pragma mark - Private

- (NSURLSessionDataTask *)dataTaskWihtMethod:(NSString *)method URL:(NSString *)URLString
                                      params:(NSDictionary *)params try:(void (^)(id responseObject))try completion:(void (^)(NSError *error))completion
{
    NSParameterAssert(try);
    NSParameterAssert(completion);
    
    return [self dataTaskWihtMethod:method URL:URLString params:params completion:^(id responseObject, NSError *_error) {
        
        dispatch_async(process_response_queue(), ^{
           
            NSError *error = _error;
            
            if (! error)
            {
                @try {
                    
                    try(responseObject);
                }
                @catch (NSException *exception) {
                    
                    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : exception.reason };
                    error = [NSError errorWithDomain:SPSeweetRestErrorDomain code:500 userInfo:userInfo];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
            
        });
    }];
}

- (NSURLSessionDataTask *)dataTaskWihtMethod:(NSString *)method URL:(NSString *)URLString
                                      params:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion
{
    NSParameterAssert(URLString);
    NSParameterAssert(completion);
    
    NSError *error = nil;
    NSURLRequest *request = [self requestWithMethod:method URL:URLString params:params error:&error];
    if (error)
    {
        completion(nil, error);
        return nil;
    }
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        //
        // Validate response
        if (! error
            && [self validateResponse:(NSHTTPURLResponse *)response data:data error:&error]
            && [self.delegate respondsToSelector:@selector(sweetRest:didReceiveResponse:)] )
        {
            [self.delegate sweetRest:self didReceiveResponse:(NSHTTPURLResponse *)response];
        }
        
        //
        // Parsing object
        id responseObject = nil;
        if (! error)
        {
            responseObject = [self responseObjectForResponse:(NSHTTPURLResponse *)response data:data error:&error];
        }
        
        //
        // Accepting response
        if (! error && [self.delegate respondsToSelector:@selector(sweetRest:shouldAcceptResponse:forObject:provideError:)])
        {
            BOOL ok = [self.delegate sweetRest:self shouldAcceptResponse:(NSHTTPURLResponse *)response forObject:responseObject provideError:&error];
            if (! ok && ! error)
            {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Unknown error", nil)};
                error = [NSError errorWithDomain:SPSeweetRestErrorDomain code:404 userInfo:userInfo];
            }
        }
        
        if (error && [self.delegate respondsToSelector:@selector(sweetRest:didFailResponse:error:)])
        {
            [self.delegate sweetRest:self didFailResponse:(NSHTTPURLResponse *)response error:error];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseObject, error);
        });
    }];
    
    [task resume];
    return task;
}

#pragma mark - Response

- (BOOL)validateResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError * __autoreleasing *)error
{
    NSError *validationError = nil;
    
    if (response && [response isKindOfClass:[NSHTTPURLResponse class]])
    {
        if (self.acceptableContentTypes && ! [self.acceptableContentTypes containsObject:response.MIMEType])
        {
            if (data.length > 0 && response.URL)
            {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat: NSLocalizedString(@"Unacceptable content-type: %@", nil), response.MIMEType]};
                validationError = [NSError errorWithDomain:SPSeweetRestErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
            }
        }
        
        if (self.acceptableStatusCodes && ! [self.acceptableStatusCodes containsIndex:(NSUInteger)response.statusCode] && response.URL)
        {
            NSString *descriptoin = [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode];
            if (! descriptoin)
            {
                descriptoin = [NSString stringWithFormat: NSLocalizedString(@"Request failed: %@ (%ld)", nil), response.statusCode];
            }
            
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : descriptoin };
            validationError = [NSError errorWithDomain:SPSeweetRestErrorDomain code:response.statusCode userInfo:userInfo];
        }
    }
    else
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Invalid server response.", nil)};
        validationError = [NSError errorWithDomain:SPSeweetRestErrorDomain code:NSURLErrorBadServerResponse userInfo:userInfo];
    }
    
    if (error && validationError)
    {
        *error = validationError;
    }
    
    return ! validationError;
}

- (id)responseObjectForResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
    // Workaround for behavior of Rails to return a single space for `head :ok` (a workaround for a bug in Safari), which is not interpreted as valid input by NSJSONSerialization.
    // See https://github.com/rails/rails/issues/1742
    NSStringEncoding stringEncoding = self.stringEncoding;
    
    if (response.textEncodingName)
    {
        CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)response.textEncodingName);
        if (encoding != kCFStringEncodingInvalidId)
        {
            stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
        }
    }
    
    id responseObject = nil;
    NSError *serializationError = nil;
    
    @autoreleasepool
    {
        NSString *responseString = [[NSString alloc] initWithData:data encoding:stringEncoding];
        
        if (responseString && ![responseString isEqualToString:@" "])
        {
            // Workaround for a bug in NSJSONSerialization when Unicode character escape codes are used instead of the actual character
            // See http://stackoverflow.com/a/12843465/157142
            
            data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (data)
            {
                if ([data length] > 0)
                {
                    responseObject = [NSJSONSerialization JSONObjectWithData:data options:self.readingOptions error:&serializationError];
                }
                else
                {
                    return nil;
                }
            }
            else
            {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Data failed decoding as a UTF-8 string", nil)};
                serializationError = [NSError errorWithDomain:SPSeweetRestErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
            }
        }
    }
    
    // Probably remove NSNull objects
    
    if (error)
    {
        *error = serializationError;
    }
    
    return responseObject;
}

#pragma mark - Request

- (NSURLRequest *)requestWithMethod:(NSString *)method URL:(NSString *)URLString params:(NSDictionary *)params error:(NSError *__autoreleasing *)error
{
    NSURL *url = [NSURL URLWithString:URLString relativeToURL:self.baseURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = method;
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (! [request valueForHTTPHeaderField:field])
        {
            [request setValue:value forHTTPHeaderField:field];
        }
    }];
    
    if (params)
    {
        NSString *query =  [SPQueryStringPair queryStringWithParams:params stringEncoding:self.stringEncoding];
        
        if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[request HTTPMethod] uppercaseString]])
        {
            request.URL = [NSURL URLWithString:[[request.URL absoluteString] stringByAppendingFormat:request.URL.query ? @"&%@" : @"?%@", query]];
        }
        else
        {
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:[query dataUsingEncoding:self.stringEncoding]];
        }
    }
    
    return request;
}

@end

NSString * const SPSeweetRestErrorDomain = @"SPSeweetRestErrorDomain";
