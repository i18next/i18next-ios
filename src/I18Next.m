//
//  I18Next.m
//  i18next
//
//  Created by Jean Regisser on 28/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "I18Next.h"
#import "NSObject+I18Next.h"
#import "NSString+I18Next.h"

static I18Next* gSharedInstance = nil;
static dispatch_once_t gOnceToken;

@implementation I18Next

+ (instancetype)sharedInstance {
    dispatch_once(&gOnceToken, ^{
        if (!gSharedInstance) {
            gSharedInstance = [[self alloc] init];
        }
    });
    return gSharedInstance;
}

+ (void)setSharedInstance:(I18Next*)instance {
    gSharedInstance = instance;
    gOnceToken = 0; // resets the once_token so dispatch_once will run again
}

+ (NSString*)t:(id)key {
    return [[self sharedInstance] t:key];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.fallbackLang = @"dev";
        self.namespace = @"translation";
        self.namespaceSeparator = @":";
        self.keySeparator = kI18NextKeySeparator;
        self.interpolationPrefix = kI18NextInterpolationPrefix;
        self.interpolationSuffix = kI18NextInterpolationSuffix;
    }
    return self;
}

- (void)setNamespace:(NSString*)ns {
    self.namespaces = @[ns];
    self.defaultNamespace = ns;
}

- (void)setFallbackNamespace:(NSString*)fallbackNS {
    self.fallbackNamespaces = @[fallbackNS];
}

- (void)load {
    
}

- (BOOL)exists:(NSString*)key {
    return !![self translateKey:key namespace:nil context:nil variables:nil defaultValue:nil];
}

- (NSString*)t:(id)key {
    return [self t:key namespace:nil context:nil variables:nil defaultValue:nil];
}

- (NSString*)t:(id)key defaultValue:(NSString*)defaultValue {
    return [self t:key namespace:nil context:nil variables:nil defaultValue:defaultValue];
}

- (NSString*)t:(id)key context:(NSString*)context {
    return [self t:key namespace:nil context:context variables:nil defaultValue:nil];
}

- (NSString*)t:(id)key context:(NSString*)context defaultValue:(NSString*)defaultValue {
    return [self t:key namespace:nil context:context variables:nil defaultValue:defaultValue];
}

- (NSString*)t:(id)key variables:(NSDictionary*)variables {
    return [self t:key namespace:nil context:nil variables:variables defaultValue:nil];
}

- (NSString*)t:(id)key variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue {
    return [self t:key namespace:nil context:nil variables:variables defaultValue:defaultValue];
}

- (NSString*)t:(id)key context:(NSString*)context variables:(NSDictionary*)variables {
    return [self t:key namespace:nil context:context variables:variables defaultValue:nil];
}

- (NSString*)t:(id)key context:(NSString*)context variables:(NSDictionary*)variables
  defaultValue:(NSString*)defaultValue {
    return [self t:key namespace:nil context:context variables:variables defaultValue:defaultValue];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace {
    return [self t:key namespace:namespace context:nil variables:nil defaultValue:nil];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace defaultValue:(NSString*)defaultValue {
    return [self t:key namespace:namespace context:nil variables:nil defaultValue:defaultValue];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace context:(NSString*)context {
    return [self t:key namespace:namespace context:context variables:nil defaultValue:nil];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace context:(NSString*)context defaultValue:(NSString*)defaultValue {
    return [self t:key namespace:namespace context:context variables:nil defaultValue:defaultValue];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace variables:(NSDictionary*)variables {
    return [self t:key namespace:namespace context:nil variables:variables defaultValue:nil];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace variables:(NSDictionary*)variables
  defaultValue:(NSString*)defaultValue {
    return [self t:key namespace:namespace context:nil variables:variables defaultValue:defaultValue];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace context:(NSString*)context variables:(NSDictionary*)variables {
    return [self t:key namespace:namespace context:context variables:variables defaultValue:nil];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace context:(NSString*)context variables:(NSDictionary*)variables
  defaultValue:(NSString*)defaultValue {
    return [self translate:key namespace:namespace context:(NSString*)context variables:variables
              defaultValue:defaultValue];
}

#pragma mark Private Methods

- (NSArray*)languagesForLang:(NSString*)lang {
    NSMutableArray* languages = [NSMutableArray array];
    
    if (lang.length) {
        // Split languageCode and countryCode
        NSRange dashRange = [lang rangeOfString:@"-"];
        if (dashRange.location != NSNotFound) {
            NSString* languageCode = [lang substringToIndex:dashRange.location].lowercaseString;
            NSString* countryCode = [lang substringFromIndex:dashRange.location + dashRange.length];
            
            countryCode = self.lowercaseLang ? countryCode.lowercaseString : countryCode.uppercaseString;
            
            if (self.langLoadType != I18NextLangLoadTypeUnspecific) {
                [languages addObject:[NSString stringWithFormat:@"%@-%@", languageCode, countryCode]];
            }
            if (self.langLoadType != I18NextLangLoadTypeCurrent) {
                [languages addObject:languageCode];
            }
        }
        else {
            [languages addObject:lang];
        }
    }
    
    NSString* fallbackLang = self.fallbackLang;
    if (fallbackLang.length && [languages indexOfObject:fallbackLang] == NSNotFound) {
        [languages addObject:fallbackLang];
    }
    
    return languages;
}

- (NSString*)translate:(id)key namespace:(NSString*)namespace context:(NSString*)context
             variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue {
    NSString* stringKey = nil;
    if ([key isKindOfClass:[NSString class]]) {
        stringKey = key;
    }
    else if ([key isKindOfClass:[NSArray class]]) {
        for (id potentialKey in key) {
            if ([potentialKey isKindOfClass:[NSString class]]) {
                stringKey = potentialKey;
                NSString* value = [self translateKey:potentialKey namespace:namespace context:context
                                           variables:variables defaultValue:defaultValue];
                if (value) {
                    return value;
                }
            }
        }
    }
    
    return [self translateKey:stringKey namespace:namespace context:context
                    variables:variables defaultValue:defaultValue ?: stringKey];
}

- (NSString*)translateKey:(NSString*)stringKey namespace:(NSString*)namespace context:(NSString*)context
                variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue {
    NSString* ns = namespace.length ? namespace : self.defaultNamespace;
    NSRange nsRange = [stringKey rangeOfString:self.namespaceSeparator];
    if (nsRange.location != NSNotFound) {
        ns = [stringKey substringToIndex:nsRange.location];
        stringKey = [stringKey substringFromIndex:nsRange.location + nsRange.length];
    }
    
    NSArray* fallbackNamespaces = self.fallbackNamespaces;
    if (!fallbackNamespaces.count && self.fallbackToDefaultNamespace) {
        fallbackNamespaces = @[self.defaultNamespace];
    }
    
    if (context.length) {
        stringKey = [stringKey stringByAppendingFormat:@"_%@", context];
    }
    
    return [self find:stringKey namespace:ns fallbackNamespaces:fallbackNamespaces variables:variables
         defaultValue:defaultValue];
}

- (NSString*)find:(NSString*)key namespace:(NSString*)ns fallbackNamespaces:(NSArray*)fallbackNamespaces
        variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue {
    NSString* result = nil;
    
    for (id lang in [self languagesForLang:self.lang]) {
        if (![lang isKindOfClass:[NSString class]]) {
            continue;
        }
        
        id value = [self.resourcesStore[lang][ns] i18n_valueForKeyPath:key keySeparator:self.keySeparator];
        if (value) {
            if ([value isKindOfClass:[NSArray class]]) {
                value = [value componentsJoinedByString:@"\n"];
            }
            result = value;
            break;
        }
    }
    
    // Not found, fallback?
    if (!result && fallbackNamespaces.count) {
        for (NSString* fallbackNS in fallbackNamespaces) {
            id value = [self find:key namespace:fallbackNS fallbackNamespaces:nil variables:variables
                     defaultValue:nil];
            if (value) {
                return value;
            }
        }
    }
    
    if (!result) {
        result = defaultValue;
    }
    
    result = [result i18n_stringByReplacingVariables:variables
                                 interpolationPrefix:self.interpolationPrefix
                                 interpolationSuffix:self.interpolationSuffix
                                        keySeparator:self.keySeparator];
    
    return result;
}

@end
