//
//  I18Next.m
//  i18next
//
//  Created by Jean Regisser on 28/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "I18Next.h"
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

- (NSString*)t:(id)key {
    return [self t:key namespace:nil context:nil variables:nil];
}

- (NSString*)t:(id)key context:(NSString*)context {
    return [self t:key namespace:nil context:context variables:nil];
}

- (NSString*)t:(id)key variables:(NSDictionary*)variables {
    return [self t:key namespace:nil context:nil variables:variables];
}

- (NSString*)t:(id)key context:(NSString*)context variables:(NSDictionary*)variables {
    return [self t:key namespace:nil context:context variables:variables];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace {
    return [self t:key namespace:namespace context:nil variables:nil];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace context:(NSString*)context {
    return [self t:key namespace:namespace context:context variables:nil];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace variables:(NSDictionary*)variables {
    return [self t:key namespace:namespace context:nil variables:variables];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace context:(NSString*)context variables:(NSDictionary*)variables {
    NSArray* fallbackNamespaces = self.fallbackNamespaces;
    if (!fallbackNamespaces.count && self.fallbackToDefaultNamespace) {
        fallbackNamespaces = @[self.defaultNamespace];
    }
    
    return [self translate:key namespace:namespace fallbackNamespaces:fallbackNamespaces
                   context:(NSString*)context variables:variables];
}

#pragma mark Private Methods

- (NSString*)translate:(id)key namespace:(NSString*)namespace fallbackNamespaces:(NSArray*)fallbackNamespaces
               context:(NSString*)context variables:(NSDictionary*)variables {
    NSString* ns = namespace.length ? namespace : self.defaultNamespace;
    NSString* stringKey = nil;
    if ([key isKindOfClass:[NSString class]]) {
        stringKey = key;
    }
    else if ([key isKindOfClass:[NSArray class]]) {
        for (id potentialKey in key) {
            if ([potentialKey isKindOfClass:[NSString class]]) {
                NSString* value = [self translate:potentialKey namespace:namespace fallbackNamespaces:fallbackNamespaces
                                          context:context variables:variables];
                if (value) {
                    return value;
                }
            }
        }
    }
    
    NSRange nsRange = [stringKey rangeOfString:self.namespaceSeparator];
    if (nsRange.location != NSNotFound) {
        ns = [stringKey substringToIndex:nsRange.location];
        stringKey = [stringKey substringFromIndex:nsRange.location + nsRange.length];
    }
    
    if (context.length) {
        stringKey = [stringKey stringByAppendingFormat:@"_%@", context];
    }
    
    return [self find:stringKey namespace:ns fallbackNamespaces:fallbackNamespaces variables:variables];
}

- (NSString*)find:(NSString*)key namespace:(NSString*)ns fallbackNamespaces:(NSArray*)fallbackNamespaces
        variables:(NSDictionary*)variables {
    for (id lang in self.resourcesStore) {
        if (![lang isKindOfClass:[NSString class]]) {
            continue;
        }
        
        id value = [self.resourcesStore[lang][ns] valueForKeyPath:key];
        if (value) {
            if ([value isKindOfClass:[NSArray class]]) {
                value = [value componentsJoinedByString:@"\n"];
            }
            value = [value i18n_stringByReplacingVariables:variables
                                       interpolationPrefix:self.interpolationPrefix
                                       interpolationSuffix:self.interpolationSuffix
                                              keySeparator:self.keySeparator];
            return value;
        }
    }
    
    // Not found, fallback?
    if (fallbackNamespaces.count) {
        for (NSString* fallbackNS in fallbackNamespaces) {
            id value = [self find:key namespace:fallbackNS fallbackNamespaces:nil variables:variables];
            if (value) {
                return value;
            }
        }
    }
    
    return nil;
}

@end
