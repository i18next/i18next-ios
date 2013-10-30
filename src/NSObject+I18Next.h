//
//  NSObject+I18Next.h
//  i18next
//
//  Created by Jean Regisser on 30/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (I18Next)

/**
 * Same as valueForKeyPath but doesn't raise an exception.
 */
- (id)i18n_valueForKeyPath:(NSString*)keyPath;
- (id)i18n_valueForKeyPath:(NSString*)keyPath keySeparator:(NSString*)keySeparator;

@end
