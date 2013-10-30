//
//  I18Next.h
//  i18next
//
//  Created by Jean Regisser on 28/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    I18NextLangLoadTypeAll = 0, // Load current and unspecific (example: 'en-US' and 'en')
    I18NextLangLoadTypeCurrent, // Load current lang set
	I18NextLangLoadTypeUnspecific // Load unspecific lang (example: 'en')
} I18NextLangLoadType;

@interface I18Next : NSObject

@property (nonatomic, copy) NSString* lang;
@property (nonatomic, assign) BOOL lowercaseLang;
@property (nonatomic, assign) I18NextLangLoadType langLoadType;
@property (nonatomic, copy) NSString* fallbackLang;
@property (nonatomic, copy) NSArray* namespaces;
@property (nonatomic, copy) NSString* defaultNamespace;
@property (nonatomic, assign) BOOL fallbackToDefaultNamespace;
@property (nonatomic, copy) NSArray* fallbackNamespaces;
@property (nonatomic, copy) NSDictionary* resourcesStore;
@property (nonatomic, copy) NSString* namespaceSeparator;
@property (nonatomic, copy) NSString* keySeparator;
@property (nonatomic, copy) NSString* interpolationPrefix;
@property (nonatomic, copy) NSString* interpolationSuffix;

+ (instancetype)sharedInstance;
+ (void)setSharedInstance:(I18Next*)instance;

+ (NSString*)t:(id)key;

- (void)setNamespace:(NSString*)ns;
- (void)setFallbackNamespace:(NSString*)fallbackNS;

- (void)load;

- (BOOL)exists:(NSString*)key;

- (NSString*)t:(id)key;
- (NSString*)t:(id)key defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key context:(NSString*)context;
- (NSString*)t:(id)key context:(NSString*)context defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key variables:(NSDictionary*)variables;
- (NSString*)t:(id)key variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key context:(NSString*)context variables:(NSDictionary*)variables;
- (NSString*)t:(id)key context:(NSString*)context variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key namespace:(NSString*)ns;
- (NSString*)t:(id)key namespace:(NSString*)ns defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key namespace:(NSString*)ns context:(NSString*)context;
- (NSString*)t:(id)key namespace:(NSString*)ns context:(NSString*)context defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key namespace:(NSString*)ns variables:(NSDictionary*)variables;
- (NSString*)t:(id)key namespace:(NSString*)ns variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key namespace:(NSString*)ns context:(NSString*)context variables:(NSDictionary*)variables;
- (NSString*)t:(id)key namespace:(NSString*)ns context:(NSString*)context variables:(NSDictionary*)variables
  defaultValue:(NSString*)defaultValue;

@end
