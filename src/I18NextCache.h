//
//  I18NextCache.h
//  i18next
//
//  Created by Jean Regisser on 06/01/14.
//  Copyright (c) 2014 PrePlay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface I18NextCache : NSObject

+ (NSDictionary*)readStoreLangs:(NSArray*)langs inDirectory:(NSString*)directory error:(NSError**)error;
+ (NSDictionary*)readBundledStoreLangs:(NSArray*)langs filename:(NSString*)filename error:(NSError**)error;

+ (void)writeStore:(NSDictionary*)store inDirectory:(NSString*)path error:(NSError**)error;

@end
