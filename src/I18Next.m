//
//  I18Next.m
//  i18next
//
//  Created by Jean Regisser on 28/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "I18Next.h"

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
        self.keySeparator = @".";
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
    return [self t:key namespace:nil];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace {
    NSString* ns = namespace.length ? namespace : self.defaultNamespace;
    NSString* stringKey = nil;
    if ([key isKindOfClass:[NSString class]]) {
        stringKey = key;
    }
    
    NSRange nsRange = [stringKey rangeOfString:self.namespaceSeparator];
    if (nsRange.location != NSNotFound) {
        ns = [stringKey substringToIndex:nsRange.location];
        stringKey = [stringKey substringFromIndex:nsRange.location + nsRange.length];
    }
    
    NSArray* fallbackNamespaces = self.fallbackNamespaces;
    if (!fallbackNamespaces.count && self.fallbackToDefaultNamespace) {
        fallbackNamespaces = @[self.defaultNamespace];
    }
    
    return [self translate:stringKey namespace:ns fallbackNamespaces:fallbackNamespaces];
}

- (NSString*)translate:(NSString*)key namespace:(NSString*)ns fallbackNamespaces:(NSArray*)fallbackNamespaces {
    for (id lang in self.resourcesStore) {
        if (![lang isKindOfClass:[NSString class]]) {
            continue;
        }
        
        id value = [self.resourcesStore[lang][ns] valueForKey:key];
        if (value) {
            return value;
        }
    }
    
    // Not found, fallback?
    if (fallbackNamespaces.count) {
        for (NSString* fallbackNS in fallbackNamespaces) {
            id value = [self translate:key namespace:fallbackNS fallbackNamespaces:nil];
            if (value) {
                return value;
            }
        }
    }
    
    return nil;
}

@end
