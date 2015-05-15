# SweetREST

SweetREST is a tiny lib for creating `http request service` of cocoa applications. 
The lib allows to send common http requests such as **GET**, **POST**, **PUT**, **PATCH**, **HEAD** and **DELETE**. It is a lightweight version of amazing [AFNetworking](https://github.com/AFNetworking/AFNetworking), with a couple of additional features like nice [error handling](#error-handling).

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries.

```ruby
platform :ios, '7.0'
pod "SweetREST"
```

###Example

To start sending requests you just need to init sweetRest with [NSURLSession](https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSURLSession_class/) and baseURL of your backend.

```objective-c
NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
self.sweetRest = [[SPSweetRest alloc] initWithSession:session baseURL:[NSURL URLWithString:@"http://example.com/json/api/"]];
```

Sending a simple GET request.

```objective-c
NSDictionary *params = @{@"name" : @"serj"};

[self.sweetRest GET:@"person" params:params completion:^(id responseObject, NSError *error) {
		
	if(! error) {
		//Success
	}
	else {
	 	//Failure
	}
		
}];
```

###Error handling
Error handling is a main feature of the lib. Unlike [AFNetworking](https://github.com/AFNetworking/AFNetworking) SweetREST is creating NSError's where codes coresponds to [http status codes](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html).
For example if your backend is responsing **401 Unauthorized**, you may handle it and expire auth token:

```objective-c
...

if (error.code == 401) {
	[self.sweetRest removeValueForHTTPHeaderField:@"XX-MY-SWEET-AUTH-TOKEN"];
}

```

One of the features is `SPSweetRestDelegate` protocol. The protocol allows listen every **valid (with status code 2xx and JSON content type)** response form the server:

```objective-c
- (void)sweetRest:(SPSweetRest *)sweetRest didReceiveResponse:(NSHTTPURLResponse *)response
{
	// Ckeck for token
	NSString *token = response.allHeaderFields[@"AUTH-TOKEN"];
	
	//Status code
	NSInteger code = response.statusCode;
	
	// Do somthing here..
}

```

Or every failure response:

```objective-c
- (void)sweetRest:(SPSweetRest *)sweetRest didFailResponse:(NSHTTPURLResponse *)response error:(NSError *)error
{
	// Do somthing here
}
```

Moreover you may provide some custom error and accept every response:

```objective-c
- (BOOL)sweetRest:(SPSweetRest *)sweetRest shouldAcceptResponse:(NSHTTPURLResponse *)response forObject:(id)responseObject provideError:(NSError **)error
{
	NSInteger code = response.statusCode;	
	if (code == 201) {
		// Provide some custom error
		NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"I do not like 201 status code!"};
        *error = [NSError errorWithDomain:SPSeweetRestErrorDomain code:777 userInfo:userInfo];
		return NO;
	}
	return YES;
}
```

## License

SweetREST is available under the MIT license. See the LICENSE file for more info.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/Serjip/sweetrest/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

