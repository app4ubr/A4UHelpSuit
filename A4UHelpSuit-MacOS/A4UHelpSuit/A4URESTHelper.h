//
// A4URESTHelper.h
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

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, A4URESTHelperUploadMediaType){
    A4URESTHelperUploadMediaTypeImage,
    A4URESTHelperUploadMediaTypeAudio,
    A4URESTHelperUploadMediaTypeVideo
};

@protocol A4URESTHelperDelegate <NSObject>
@optional
- (void)willStartUploading;
- (void)didFinishUploading;
- (void)didFailWithError:(NSError *)error;
- (void)trackProgress:(double)progress;
- (void)finishedUploadingContent:(NSDictionary *)dict;
@end

/**
 * @class A4URESTHelper
 * @author Thiago Cruz
 * @date 04/08/2014
 *
 * @version 1.0
 *
 * @discussion THIS CLASS HANDLES ALL INTERACTIONS WITH WEBSERVICES AND INTERNET
 */

@interface A4URESTHelper : NSObject
@property (nonatomic) id<A4URESTHelperDelegate>delegate;
@property (nonatomic, strong) NSError      * localError;
@property (nonatomic, strong) NSDictionary * uploadDict;
@property (nonatomic, assign) double progress;

+ (instancetype)sharedHelper;
- (void)POSTWithURL:(NSString *)URL
             params:(NSDictionary *)params
         completion:(void(^)(id result))completionBlock
              error:(void(^)(NSError *error))errorBlock;
- (void)alternativePostWithURL:(NSString*)url
                    completion:(void(^)(id result))completionBlock
                         error:(void(^)(NSError *error))errorBlock;
- (NSString*)form_urlencode_HTTP5_String:(NSString *)s;
+ (void)startMonitoringNetwork;
+ (BOOL)isInternetOn;
@end