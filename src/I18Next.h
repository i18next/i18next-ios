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

extern NSString* const kI18NextPluralSuffix;

extern NSString* const kI18NextTranslateOptionLang;
extern NSString* const kI18NextTranslateOptionNamespace;
extern NSString* const kI18NextTranslateOptionContext;
extern NSString* const kI18NextTranslateOptionCount;
extern NSString* const kI18NextTranslateOptionVariables;
extern NSString* const kI18NextTranslateOptionDefaultValue;
extern NSString* const kI18NextTranslateOptionSprintf;

// Helper methods that end up using `t:options:`
@protocol I18NextDynamicInterface <NSObject>

@optional

- (NSString*)t:(id)key;
- (NSString*)t:(id)key defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key lang:(NSString*)lang;
- (NSString*)t:(id)key lang:(NSString*)lang defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key count:(NSUInteger)count;
- (NSString*)t:(id)key lang:(NSString*)lang count:(NSUInteger)count;
- (NSString*)t:(id)key count:(NSUInteger)count defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key lang:(NSString*)lang count:(NSUInteger)count defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key context:(NSString*)context;
- (NSString*)t:(id)key lang:(NSString*)lang context:(NSString*)context;
- (NSString*)t:(id)key context:(NSString*)context count:(NSUInteger)count;
- (NSString*)t:(id)key lang:(NSString*)lang context:(NSString*)context count:(NSUInteger)count;
- (NSString*)t:(id)key context:(NSString*)context defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key lang:(NSString*)lang context:(NSString*)context defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key context:(NSString*)context count:(NSUInteger)count defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key lang:(NSString*)lang context:(NSString*)context count:(NSUInteger)count defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key variables:(NSDictionary*)variables;
- (NSString*)t:(id)key lang:(NSString*)lang variables:(NSDictionary*)variables;
- (NSString*)t:(id)key count:(NSUInteger)count variables:(NSDictionary*)variables;
- (NSString*)t:(id)key lang:(NSString*)lang count:(NSUInteger)count variables:(NSDictionary*)variables;
- (NSString*)t:(id)key variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key lang:(NSString*)lang variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key count:(NSUInteger)count variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key lang:(NSString*)lang count:(NSUInteger)count variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key context:(NSString*)context variables:(NSDictionary*)variables;
- (NSString*)t:(id)key lang:(NSString*)lang context:(NSString*)context variables:(NSDictionary*)variables;
- (NSString*)t:(id)key context:(NSString*)context count:(NSUInteger)count variables:(NSDictionary*)variables;
- (NSString*)t:(id)key lang:(NSString*)lang context:(NSString*)context count:(NSUInteger)count variables:(NSDictionary*)variables;
- (NSString*)t:(id)key context:(NSString*)context variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key lang:(NSString*)lang context:(NSString*)context variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key context:(NSString*)context count:(NSUInteger)count variables:(NSDictionary*)variables
  defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key lang:(NSString*)lang context:(NSString*)context count:(NSUInteger)count variables:(NSDictionary*)variables
  defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key namespace:(NSString*)ns;
- (NSString*)t:(id)key lang:(NSString*)lang namespace:(NSString*)ns;
- (NSString*)t:(id)key namespace:(NSString*)ns count:(NSUInteger)count;
- (NSString*)t:(id)key lang:(NSString*)lang namespace:(NSString*)ns count:(NSUInteger)count;
- (NSString*)t:(id)key namespace:(NSString*)ns defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key lang:(NSString*)lang namespace:(NSString*)ns defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key namespace:(NSString*)ns count:(NSUInteger)count defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key lang:(NSString*)lang namespace:(NSString*)ns count:(NSUInteger)count defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key namespace:(NSString*)ns context:(NSString*)context;
- (NSString*)t:(id)key lang:(NSString*)lang namespace:(NSString*)ns context:(NSString*)context;
- (NSString*)t:(id)key namespace:(NSString*)ns context:(NSString*)context count:(NSUInteger)count;
- (NSString*)t:(id)key lang:(NSString*)lang namespace:(NSString*)ns context:(NSString*)context count:(NSUInteger)count;
- (NSString*)t:(id)key namespace:(NSString*)ns context:(NSString*)context defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key lang:(NSString*)lang namespace:(NSString*)ns context:(NSString*)context defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key namespace:(NSString*)ns context:(NSString*)context count:(NSUInteger)count
  defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key lang:(NSString*)lang namespace:(NSString*)ns context:(NSString*)context count:(NSUInteger)count
  defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key namespace:(NSString*)ns variables:(NSDictionary*)variables;
- (NSString*)t:(id)key lang:(NSString*)lang namespace:(NSString*)ns variables:(NSDictionary*)variables;
- (NSString*)t:(id)key namespace:(NSString*)ns count:(NSUInteger)count variables:(NSDictionary*)variables;
- (NSString*)t:(id)key lang:(NSString*)lang namespace:(NSString*)ns count:(NSUInteger)count variables:(NSDictionary*)variables;
- (NSString*)t:(id)key namespace:(NSString*)ns variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key lang:(NSString*)lang namespace:(NSString*)ns variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key namespace:(NSString*)ns count:(NSUInteger)count variables:(NSDictionary*)variables
  defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key lang:(NSString*)lang namespace:(NSString*)ns count:(NSUInteger)count variables:(NSDictionary*)variables
  defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key namespace:(NSString*)ns context:(NSString*)context variables:(NSDictionary*)variables;
- (NSString*)t:(id)key lang:(NSString*)lang namespace:(NSString*)ns context:(NSString*)context variables:(NSDictionary*)variables;
- (NSString*)t:(id)key namespace:(NSString*)ns context:(NSString*)context count:(NSUInteger)count
     variables:(NSDictionary*)variables;
- (NSString*)t:(id)key lang:(NSString*)lang namespace:(NSString*)ns context:(NSString*)context count:(NSUInteger)count
     variables:(NSDictionary*)variables;
- (NSString*)t:(id)key namespace:(NSString*)ns context:(NSString*)context variables:(NSDictionary*)variables
  defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key lang:(NSString*)lang namespace:(NSString*)ns context:(NSString*)context variables:(NSDictionary*)variables
  defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key namespace:(NSString*)ns context:(NSString*)context count:(NSUInteger)count
     variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue;
- (NSString*)t:(id)key lang:(NSString*)lang namespace:(NSString*)ns context:(NSString*)context count:(NSUInteger)count
     variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue;

@end

@class I18NextPlurals;

@interface I18Next : NSObject<I18NextDynamicInterface>

@property (nonatomic, copy) NSString* lang;
@property (nonatomic, assign) BOOL lowercaseLang;
@property (nonatomic, assign) I18NextLangLoadType langLoadType;
@property (nonatomic, copy) NSString* fallbackLang;
@property (nonatomic, copy) NSArray* namespaces;
@property (nonatomic, copy) NSString* defaultNamespace;
@property (nonatomic, assign) BOOL fallbackToDefaultNamespace;
@property (nonatomic, copy) NSArray* fallbackNamespaces;
@property (nonatomic, assign) BOOL fallbackOnNull;
@property (nonatomic, assign) BOOL returnObjectTrees;
@property (nonatomic, copy) NSDictionary* resourcesStore;
@property (nonatomic, copy) NSString* namespaceSeparator;
@property (nonatomic, copy) NSString* keySeparator;
@property (nonatomic, copy) NSString* interpolationPrefix;
@property (nonatomic, copy) NSString* interpolationSuffix;
@property (nonatomic, copy) NSString* pluralSuffix;

@property (nonatomic, strong) I18NextPlurals* plurals;

+ (instancetype)sharedInstance;
+ (void)setSharedInstance:(I18Next*)instance;

+ (NSString*)t:(id)key;

- (void)setNamespace:(NSString*)ns;
- (void)setFallbackNamespace:(NSString*)fallbackNS;

- (void)load;

- (BOOL)exists:(NSString*)key;

- (NSString*)t:(id)key, ...;
- (NSString*)t:(id)key options:(NSDictionary*)options;

@end

#define I18NEXT_SPRINTF_ARGS(...) \
    [I18NextSprintfArgs formatBlock:^(NSString* format) { \
    return [I18NextSprintf sprintf:format, ##__VA_ARGS__]; \
    }]

@interface I18NextSprintfArgs : NSObject

@property (nonatomic, copy) NSString* (^formatBlock)(NSString* format);

+ (instancetype)formatBlock:(NSString* (^)(NSString* format))formatBlock;

@end

@interface I18NextSprintf : NSObject

+ (NSString*)sprintf:(NSString*)format, ...;
+ (NSString*)vsprintf:(NSString*)format arguments:(va_list)argList;

@end
