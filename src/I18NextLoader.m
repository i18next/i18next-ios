//
//  I18NextLoader.m
//  i18next
//
//  Created by Jean Regisser on 07/11/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "I18NextLoader.h"
#import "I18NextConnection.h"
#import "NSString+I18Next.h"

@interface I18NextLoader ()

@property (nonatomic, strong) I18NextOptions* optionsObject;

@property (nonatomic, strong) NSMutableArray* currentConnections;
@property (nonatomic, strong) NSOperationQueue* backgroundQueue;

@end

@implementation I18NextLoader

- (instancetype)initWithOptions:(I18NextOptions*)options {
    self = [super init];
    if (self) {
        self.optionsObject = options;
        
        self.backgroundQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)loadLangs:(NSArray*)langs namespaces:(NSArray*)namespaces completion:(void (^)(NSDictionary* store, NSError* error))completionBlock {
    __block NSMutableDictionary* store = nil;
    
    NSMutableArray* oldConnections = self.currentConnections;
    self.currentConnections = nil;
    [oldConnections makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableArray* connections = [NSMutableArray array];
    NSMutableArray* errors = [NSMutableArray array];
    for (NSString* lang in langs) {
        for (NSString* ns in namespaces) {
            NSString* getPath = [self.optionsObject.resourcesGetPathTemplate i18n_stringByReplacingVariables:@{ @"lng": lang, @"ns": ns }
                                                                                         interpolationPrefix:self.optionsObject.interpolationPrefix
                                                                                         interpolationSuffix:self.optionsObject.interpolationSuffix];
            NSString* langURLString = [self.optionsObject.resourcesBaseURL.absoluteString
                                       stringByAppendingPathComponent:getPath];
            NSURL* langURL = [NSURL URLWithString:langURLString];
            NSURLRequest* request = [NSURLRequest requestWithURL:langURL];
            
            __block I18NextConnection* connection =
            [I18NextConnection asynchronousRequest:request queue:self.backgroundQueue
                                 completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                     NSDictionary* json = nil;
                                     NSError* returnError = error;
                                     if (!error) {
                                         if (data) {
                                             NSError* jsonParseError = nil;
                                             json = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data
                                                                                                    options:kNilOptions
                                                                                                      error:&jsonParseError];
                                             
                                             if (jsonParseError) {
                                                 // invalid json
                                                 returnError = [NSError errorWithDomain:I18NextErrorDomain
                                                                                   code:I18NextErrorInvalidLangData
                                                                               userInfo:@{ NSURLErrorFailingURLErrorKey: langURL,
                                                                                           NSUnderlyingErrorKey: jsonParseError }];
                                             }
                                         }
                                         else {
                                             // no data error
                                             returnError = [NSError errorWithDomain:I18NextErrorDomain code:I18NextErrorInvalidLangData
                                                                           userInfo:@{ NSURLErrorFailingURLErrorKey: langURL }];
                                         }
                                     }
                                     
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         if (json) {
                                             if (!store) {
                                                 store = [NSMutableDictionary dictionary];
                                             }
                                             if (!store[lang]) {
                                                 store[lang] = [NSMutableDictionary dictionary];
                                             }
                                             store[lang][ns] = json;
                                         }
                                         
                                         if (returnError) {
                                             [errors addObject:returnError];
                                         }
                                         
                                         [connections removeObject:connection];
                                         if (connections.count == 0 && completionBlock) {
                                             NSError* aggregateError = nil;
                                             if (errors.count > 0) {
                                                 aggregateError = [NSError errorWithDomain:I18NextErrorDomain code:I18NextErrorLoadFailed
                                                                                  userInfo:@{ I18NextDetailedErrorsKey: errors.copy }];
                                             }
                                             completionBlock(store, aggregateError);
                                         }
                                     });
                                 }];
            
            [connections addObject:connection];
        }
        
    }
    
    self.currentConnections = connections;
    [connections makeObjectsPerformSelector:@selector(start)];
}

@end
