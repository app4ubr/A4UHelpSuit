//
// A4URESTHelper.m
// A4UHelpSuit
//
// Created by Thiago Cruz on 04/08/14.
// Copyright (c) 2011–2016 App4U Sistemas de Informação Ltda. (contact@app4u.com.br)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "A4URESTHelper.h"
#import <objc/runtime.h>

@implementation A4URESTHelper
//{
//    AFHTTPRequestOperation *httpRequestOperation;
//}

#pragma mark - Standard Methods

+ (instancetype)sharedHelper {
    static dispatch_once_t pred;
    static id shared = nil;
    
    dispatch_once(&pred,^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (void)POSTWithURL:(NSString *)URL
             params:(NSDictionary *)params
         completion:(void(^)(id result))completionBlock
              error:(void(^)(NSError *error))errorBlock {
    NSURLSessionConfiguration *config   = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager       = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    manager.requestSerializer           = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET",@"HEAD",@"DELETE",nil];
    manager.requestSerializer.timeoutInterval                    = 40.0f;
    manager.requestSerializer.queryStringSerializationWithBlock  =
    ^NSString*(NSURLRequest *request,
               NSDictionary *parameters,
               NSError *__autoreleasing *error) {
        NSString* encodedParams = form_urlencode_HTTP5_Parameters(parameters);
        return encodedParams;
    };
    
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.delegate willStartUploading];
    [manager POST:URL
       parameters:params
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionBlock(responseObject);
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
    }];
    
}

- (void)alternativePostWithURL:(NSString*)url
                    completion:(void(^)(id result))completionBlock
                         error:(void(^)(NSError *error))errorBlock {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSError *error = nil;
        NSData  *data  = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:0 error:&error];
        if (error)
            errorBlock(error);
        completionBlock([NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]);
    });
}

- (NSString *)form_urlencode_HTTP5_String:(NSString *)s {
    NSString *string = form_urlencode_HTTP5_String(s);
    return string;
}

static NSString* form_urlencode_HTTP5_String(NSString* s) {
    NSString *result =  [s stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

static NSString* form_urlencode_HTTP5_Parameters(NSDictionary* parameters) {
    NSMutableString* result = [[NSMutableString alloc] init];
    BOOL isFirst = YES;
    for (NSString* name in parameters) {
        if (!isFirst) {
            [result appendString:@"&"];
        }
        isFirst = NO;
        assert([name isKindOfClass:[NSString class]]);
        NSString* value = parameters[name];
        assert([value isKindOfClass:[NSString class]]);
        
        NSString* encodedName  = form_urlencode_HTTP5_String(name);
        NSString* encodedValue = form_urlencode_HTTP5_String(value);
        [result appendString:encodedName];
        [result appendString:@"="];
        [result appendString:encodedValue];
    }
    return [result copy];
}

#pragma mark - Network Activity

+ (void)startMonitoringNetwork {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (BOOL)isInternetOn {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

@end
