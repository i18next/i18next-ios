//
//  NSObject+I18Next.m
//  i18next
//
//  Created by Jean Regisser on 30/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "NSObject+I18Next.h"

@implementation NSObject (I18Next)

- (id)i18n_valueForKeyPath:(NSString *)keyPath {
    id object = nil;
    @try {
		object = [self valueForKeyPath:keyPath];
	}
	@catch (NSException *exception) {
		NSLog(@"Unable to get value for keyPath:%@, exception: %@", keyPath, exception);
	}
    
    return object;
}
    
- (id)i18n_valueForKeyPath:(NSString *)keyPath keySeparator:(NSString*)keySeparator {
    NSString* newKeyPath = [keyPath stringByReplacingOccurrencesOfString:keySeparator withString:@"."];
    return [self i18n_valueForKeyPath:newKeyPath];
    
}

@end
