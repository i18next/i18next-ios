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
@property (nonatomic, copy) NSArray* namespaces;
@property (nonatomic, copy) NSString* defaultNamespace;
@property (nonatomic, assign) BOOL fallbackToDefaultNamespace;
@property (nonatomic, copy) NSArray* fallbackNamespaces;
@property (nonatomic, copy) NSDictionary* resourcesStore;
@property (nonatomic, copy) NSString* namespaceSeparator;
@property (nonatomic, copy) NSString* keySeparator;

+ (instancetype)sharedInstance;
+ (void)setSharedInstance:(I18Next*)instance;

+ (NSString*)t:(id)key;

- (void)setNamespace:(NSString*)ns;
- (void)setFallbackNamespace:(NSString*)fallbackNS;

- (void)load;

- (NSString*)t:(id)key;
- (NSString*)t:(id)key variables:(NSDictionary*)variables;
- (NSString*)t:(id)key namespace:(NSString*)ns;
- (NSString*)t:(id)key namespace:(NSString*)ns variables:(NSDictionary*)variables;

@end
