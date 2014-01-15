//
//  NSString+I18Next.m
//  i18next
//
//  Created by Jean Regisser on 29/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "NSString+I18Next.h"
#import "NSObject+I18Next.h"

NSString* const kI18NextInterpolationPrefix = @"__";
NSString* const kI18NextInterpolationSuffix = @"__";
NSString* const kI18NextKeySeparator = @".";

@implementation NSString (I18Next)

- (NSString*)i18n_stringByReplacingVariables:(NSDictionary*)variables {
    return [self i18n_stringByReplacingVariables:variables
                             interpolationPrefix:kI18NextInterpolationPrefix
                             interpolationSuffix:kI18NextInterpolationSuffix
                                    keySeparator:kI18NextKeySeparator];
}

- (NSString*)i18n_stringByReplacingVariables:(NSDictionary*)variables
                         interpolationPrefix:(NSString*)interpolationPrefix
                         interpolationSuffix:(NSString*)interpolationSuffix {
    return [self i18n_stringByReplacingVariables:variables
                             interpolationPrefix:interpolationPrefix
                             interpolationSuffix:interpolationSuffix
                                    keySeparator:kI18NextKeySeparator];
}

- (NSString*)i18n_stringByReplacingVariables:(NSDictionary*)variables
                         interpolationPrefix:(NSString*)interpolationPrefix
                         interpolationSuffix:(NSString*)interpolationSuffix
                                keySeparator:(NSString*)keySeparator {
    NSError* error = nil;
    
    NSRegularExpression* regex =
    [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"%@((?:\\w(?:%@)*)+)%@",
                                                       [NSRegularExpression escapedPatternForString:interpolationPrefix],
                                                       [NSRegularExpression escapedPatternForString:keySeparator],
                                                       [NSRegularExpression escapedPatternForString:interpolationSuffix]]
                                              options:0 error:&error];
    NSMutableSet* keys = [NSMutableSet set];
    [regex enumerateMatchesInString:self options:0 range:NSMakeRange(0, self.length)
                         usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                             if (match.numberOfRanges > 1) {
                                 [keys addObject:[self substringWithRange:[match rangeAtIndex:1]]];
                             }
                         }];
    
    NSString* result = self;
    
    for (NSString* key in keys) {
        id value = [variables i18n_valueForKeyPath:key keySeparator:keySeparator];
        if (value) {
            result = [result stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%@%@",
                                                                   interpolationPrefix, key, interpolationSuffix]
                                                       withString:[value description]];
        }
    }
    
    return result;
}

@end
