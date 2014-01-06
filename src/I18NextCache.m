//
//  I18NextCache.m
//  i18next
//
//  Created by Jean Regisser on 06/01/14.
//  Copyright (c) 2014 PrePlay, Inc. All rights reserved.
//

#import "I18NextCache.h"
#import "I18Next.h"

@implementation I18NextCache

+ (NSDictionary*)readStoreLangs:(NSArray*)langs inDirectory:(NSString*)path error:(NSError**)error {
    NSMutableArray* langsToRead = [NSMutableArray array];
    NSMutableArray* paths = [NSMutableArray array];
    
    for (id l in langs) {
        if ([l isKindOfClass:[NSString class]]) {
            NSString* lang = l;
            NSString* langFile = [path stringByAppendingPathComponent:[lang stringByAppendingPathExtension:@"json"]];
            if (langFile) {
                [langsToRead addObject:lang];
                [paths addObject:langFile];
            }
        }
    }
    
    return [self readStoreLangs:langsToRead atPaths:paths error:error];
}

+ (NSDictionary*)readBundledStoreLangs:(NSArray*)langs filename:(NSString*)filename error:(NSError**)error {
    NSMutableArray* langsToRead = [NSMutableArray array];
    NSMutableArray* paths = [NSMutableArray array];
    
    for (id l in langs) {
        if ([l isKindOfClass:[NSString class]]) {
            NSString* lang = l;
            NSString* path = [[NSBundle bundleForClass:[self class]] pathForResource:lang ofType:@"lproj"];
            NSString* langFile = [path stringByAppendingPathComponent:filename];
            if (langFile) {
                [langsToRead addObject:lang];
                [paths addObject:langFile];
            }
        }
    }
    
    return [self readStoreLangs:langsToRead atPaths:paths error:error];
}

+ (NSDictionary*)readStoreLangs:(NSArray*)langs atPaths:(NSArray*)paths error:(NSError**)error {
    NSParameterAssert(langs.count == paths.count);
    
    NSMutableArray* errors = [NSMutableArray array];
    
    NSMutableDictionary* store = [NSMutableDictionary dictionary];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    for (NSUInteger i = 0; i < langs.count; ++i) {
        NSString* lang = langs[i];
        NSString* langFile = paths[i];
        if ([fileManager fileExistsAtPath:langFile]) {
            NSError* readError = nil;
            NSData* data = [NSData dataWithContentsOfFile:langFile options:kNilOptions error:&readError];
            
            if (readError) {
                [errors addObject:readError];
            }
            if (data) {
                NSError* jsonError = nil;
                id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                
                if (jsonError) {
                    [errors addObject:jsonError];
                }
                if (![jsonObject isKindOfClass:[NSDictionary class]]) {
                    [errors addObject:
                     [NSError errorWithDomain:I18NextErrorDomain code:I18NextErrorInvalidLangData
                                     userInfo:nil]];
                }
                else {
                    store[lang] = jsonObject;
                }
            }
        }
    }
    
    if (errors.count > 0 && error) {
        *error = [NSError errorWithDomain:I18NextErrorDomain code:I18NextErrorCacheReadFailed
                                 userInfo:@{ I18NextDetailedErrorsKey: errors.copy }];
    }
    
    if (store.count) {
        return store.copy;
    }
    
    return nil;
}

+ (void)writeStore:(NSDictionary*)store inDirectory:(NSString*)path error:(NSError**)error {
    NSMutableArray* errors = [NSMutableArray array];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *createDirectoryError = nil;
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&createDirectoryError];
    if (createDirectoryError) {
        [errors addObject:createDirectoryError];
    }
    else {
        [store enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([key isKindOfClass:[NSString class]]) {
                NSString* lang = key;
                NSError* jsonError = nil;
                NSData* data = [NSJSONSerialization dataWithJSONObject:obj options:kNilOptions error:&jsonError];
                if (jsonError) {
                    [errors addObject:jsonError];
                }
                if (data) {
                    NSString* langFile = [path stringByAppendingPathComponent:[lang stringByAppendingPathExtension:@"json"]];
                    NSError* writeError = nil;
                    [data writeToFile:langFile options:NSDataWritingAtomic error:&writeError];
                    
                    if (writeError) {
                        [errors addObject:writeError];
                    }
                }
            }
        }];
    }
    
    if (errors.count > 0 && error) {
        *error = [NSError errorWithDomain:I18NextErrorDomain code:I18NextErrorCacheWriteFailed
                                 userInfo:@{ I18NextDetailedErrorsKey: errors.copy }];
    }
}

@end
