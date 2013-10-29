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
    }
    return self;
}

- (void)load {
    
}

- (NSString*)t:(id)key {
    for (id lang in self.resourcesStore) {
        if (![lang isKindOfClass:[NSString class]]) {
            continue;
        }
        
        id value = [self.resourcesStore[lang][self.namespace] valueForKey:key];
        if (value) {
            return value;
        }
    }
    
    return nil;
}

@end
