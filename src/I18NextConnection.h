//
//  I18NextConnection.h
//  i18next
//
//  Created by Jean Regisser on 07/11/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// Based on https://gist.github.com/leonardvandriel/3794804
// NWURLConnection - an NSURLConnectionDelegate based on blocks with cancel.
// Similar to the `sendAsynchronousRequest:` method of NSURLConnection, but
// with `cancel` method. Requires ARC on iOS 6 or Mac OS X 10.8.
// License: BSD
// Author:  Leonard van Driel, 2012

@interface I18NextConnection : NSObject<NSURLConnectionDelegate>

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, copy) void(^completionHandler)(NSURLResponse *response, NSData *data, NSError *error);

+ (instancetype)asynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue
                  completionHandler:(void(^)(NSURLResponse *response, NSData *data, NSError *error))completionHandler;
+ (instancetype)sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue
                      completionHandler:(void(^)(NSURLResponse *response, NSData *data, NSError *error))completionHandler;

- (instancetype)initWithRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue
              completionHandler:(void(^)(NSURLResponse *response, NSData *data, NSError *error))completionHandler
               startImmediately:(BOOL)start;

- (void)start;
- (void)cancel;

@end
