//
//  I18Next.h
//  i18next
//
//  Created by Jean Regisser on 28/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface I18Next : NSObject

@property (nonatomic, copy) NSString* lang;
@property (nonatomic, copy) NSString* namespace;
@property (nonatomic, copy) NSDictionary* resourcesStore;

+ (instancetype)sharedInstance;
+ (void)setSharedInstance:(I18Next*)instance;

+ (NSString*)t:(id)key;

- (void)load;

- (NSString*)t:(id)key;

@end
