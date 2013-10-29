//
//  NSString+I18Next.h
//  i18next
//
//  Created by Jean Regisser on 29/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const kI18NextInterpolationPrefix;
extern NSString* const kI18NextInterpolationSuffix;
extern NSString* const kI18NextKeySeparator;

@interface NSString (I18Next)

- (NSString*)i18n_stringByReplacingVariables:(NSDictionary*)variables;
- (NSString*)i18n_stringByReplacingVariables:(NSDictionary*)variables
                         interpolationPrefix:(NSString*)interpolationPrefix
                         interpolationSuffix:(NSString*)interpolationSuffix;
- (NSString*)i18n_stringByReplacingVariables:(NSDictionary*)variables
                         interpolationPrefix:(NSString*)interpolationPrefix
                         interpolationSuffix:(NSString*)interpolationSuffix
                                keySeparator:(NSString*)keySeparator;

@end
