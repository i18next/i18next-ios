//
//  I18NextConnection.m
//  i18next
//
//  Created by Jean Regisser on 07/11/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "I18NextConnection.h"

@interface I18NextConnection ()

@property (nonatomic, strong) NSURLConnection* connection;
@property (nonatomic, strong) NSHTTPURLResponse* response;
@property (nonatomic, strong) NSMutableData* responseData;

@end

@implementation I18NextConnection

+ (instancetype)asynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue
                      completionHandler:(void(^)(NSURLResponse *response, NSData *data, NSError *error))completionHandler {
    return [[self alloc] initWithRequest:request queue:queue completionHandler:completionHandler startImmediately:NO];
}

+ (instancetype)sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue
                      completionHandler:(void(^)(NSURLResponse *response, NSData *data, NSError *error))completionHandler {
    return [[self alloc] initWithRequest:request queue:queue completionHandler:completionHandler startImmediately:YES];
}

- (instancetype)initWithRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue
              completionHandler:(void(^)(NSURLResponse *response, NSData *data, NSError *error))completionHandler
               startImmediately:(BOOL)start {
    self = [super init];
    if (self) {
        self.request = request;
        self.queue = queue;
        self.completionHandler = completionHandler;
        if (start) {
            [self start];
        }
    }
    return self;
}

- (void)dealloc {
    [self cancel];
}

- (void)start {
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
    self.connection = connection;
    [connection scheduleInRunLoop:NSRunLoop.mainRunLoop forMode:NSDefaultRunLoopMode];
    [connection start];
}

- (void)cancel {
    [self.connection cancel];
    self.connection = nil;
    
    NSDictionary *userInfo = nil;
    if (self.request.URL) {
        userInfo = @{ NSURLErrorFailingURLErrorKey: self.request.URL };
    }
    NSError* error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:userInfo];
    [self completeWithResponse:self.response data:self.responseData error:error];
}

- (void)completeWithResponse:(NSURLResponse*)response data:(NSData*)data error:(NSError*)error {
    if (self.completionHandler) {
        void(^b)(NSURLResponse *response, NSData *data, NSError *error) = self.completionHandler;
        self.completionHandler = nil;
        [self.queue addOperationWithBlock:^{b(response, data, error);}];
    }
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (!self.responseData) {
        self.responseData = [NSMutableData dataWithData:data];
    } else {
        [self.responseData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)_connection {
    self.connection = nil;
    [self completeWithResponse:self.response data:self.responseData error:nil];
}

- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error {
    self.connection = nil;
    [self completeWithResponse:self.response data:self.responseData error:error];
}

@end