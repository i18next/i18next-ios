//
//  I18Next.m
//  i18next
//
//  Created by Jean Regisser on 28/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "I18Next.h"
#import "I18NextPlurals.h"
#import "NSObject+I18Next.h"
#import "NSString+I18Next.h"

NSString* const kI18NextPluralSuffix = @"_plural";

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
        self.fallbackOnNull = YES;
        self.namespace = @"translation";
        self.namespaceSeparator = @":";
        self.keySeparator = kI18NextKeySeparator;
        self.interpolationPrefix = kI18NextInterpolationPrefix;
        self.interpolationSuffix = kI18NextInterpolationSuffix;
        self.pluralSuffix = kI18NextPluralSuffix;
        
        self.plurals = [I18NextPlurals sharedInstance];
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
    return !![self translateKey:key namespace:nil context:nil count:nil variables:nil defaultValue:nil];
}

- (NSString*)t:(id)key {
    return [self translate:key namespace:nil context:nil count:nil variables:nil defaultValue:nil];
}

- (NSString*)t:(id)key count:(NSUInteger)count {
    return [self translate:key namespace:nil context:nil count:@(count) variables:nil
              defaultValue:nil];
}

- (NSString*)t:(id)key defaultValue:(NSString*)defaultValue {
    return [self translate:key namespace:nil context:nil count:nil variables:nil defaultValue:defaultValue];
}

- (NSString*)t:(id)key count:(NSUInteger)count defaultValue:(NSString*)defaultValue {
    return [self translate:key namespace:nil context:nil count:@(count) variables:nil
              defaultValue:defaultValue];
}

- (NSString*)t:(id)key context:(NSString*)context {
    return [self translate:key namespace:nil context:context count:nil variables:nil defaultValue:nil];
}

- (NSString*)t:(id)key context:(NSString*)context count:(NSUInteger)count {
    return [self translate:key namespace:nil context:context count:@(count) variables:nil
              defaultValue:nil];
}

- (NSString*)t:(id)key context:(NSString*)context defaultValue:(NSString*)defaultValue {
    return [self translate:key namespace:nil context:context count:nil variables:nil defaultValue:defaultValue];
}

- (NSString*)t:(id)key context:(NSString*)context count:(NSUInteger)count defaultValue:(NSString*)defaultValue {
    return [self translate:key namespace:nil context:context count:@(count) variables:nil
              defaultValue:defaultValue];
}

- (NSString*)t:(id)key variables:(NSDictionary*)variables {
    return [self translate:key namespace:nil context:nil count:nil variables:variables defaultValue:nil];
}

- (NSString*)t:(id)key count:(NSUInteger)count variables:(NSDictionary*)variables {
    return [self translate:key namespace:nil context:nil count:@(count) variables:variables
              defaultValue:nil];
}

- (NSString*)t:(id)key variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue {
    return [self translate:key namespace:nil context:nil count:nil variables:variables defaultValue:defaultValue];
}

- (NSString*)t:(id)key count:(NSUInteger)count variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue {
    return [self translate:key namespace:nil context:nil count:@(count) variables:variables
              defaultValue:defaultValue];
}

- (NSString*)t:(id)key context:(NSString*)context variables:(NSDictionary*)variables {
    return [self translate:key namespace:nil context:context count:nil variables:variables defaultValue:nil];
}

- (NSString*)t:(id)key context:(NSString*)context count:(NSUInteger)count variables:(NSDictionary*)variables {
    return [self translate:key namespace:nil context:context count:@(count) variables:variables
              defaultValue:nil];
}

- (NSString*)t:(id)key context:(NSString*)context variables:(NSDictionary*)variables
  defaultValue:(NSString*)defaultValue {
    return [self translate:key namespace:nil context:context count:nil variables:variables defaultValue:defaultValue];
}

- (NSString*)t:(id)key context:(NSString*)context count:(NSUInteger)count variables:(NSDictionary*)variables
  defaultValue:(NSString*)defaultValue {
    return [self translate:key namespace:nil context:context count:@(count) variables:variables
              defaultValue:defaultValue];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace {
    return [self translate:key namespace:namespace context:nil count:nil variables:nil defaultValue:nil];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace count:(NSUInteger)count {
    return [self translate:key namespace:namespace context:nil count:@(count) variables:nil
              defaultValue:nil];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace defaultValue:(NSString*)defaultValue {
    return [self translate:key namespace:namespace context:nil count:nil variables:nil defaultValue:defaultValue];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace count:(NSUInteger)count defaultValue:(NSString*)defaultValue {
    return [self translate:key namespace:namespace context:nil count:@(count) variables:nil
              defaultValue:defaultValue];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace context:(NSString*)context {
    return [self translate:key namespace:namespace context:context count:nil variables:nil defaultValue:nil];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace context:(NSString*)context count:(NSUInteger)count {
    return [self translate:key namespace:namespace context:context count:@(count) variables:nil
              defaultValue:nil];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace context:(NSString*)context defaultValue:(NSString*)defaultValue {
    return [self translate:key namespace:namespace context:context count:nil variables:nil defaultValue:defaultValue];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace context:(NSString*)context count:(NSUInteger)count
  defaultValue:(NSString*)defaultValue {
    return [self translate:key namespace:namespace context:context count:@(count) variables:nil
              defaultValue:defaultValue];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace variables:(NSDictionary*)variables {
    return [self translate:key namespace:namespace context:nil count:nil variables:variables defaultValue:nil];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace count:(NSUInteger)count variables:(NSDictionary*)variables {
    return [self translate:key namespace:namespace context:nil count:@(count) variables:variables
              defaultValue:nil];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace variables:(NSDictionary*)variables
  defaultValue:(NSString*)defaultValue {
    return [self translate:key namespace:namespace context:nil count:nil variables:variables defaultValue:defaultValue];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace count:(NSUInteger)count variables:(NSDictionary*)variables
  defaultValue:(NSString*)defaultValue {
    return [self translate:key namespace:namespace context:nil count:@(count) variables:variables
              defaultValue:defaultValue];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace context:(NSString*)context variables:(NSDictionary*)variables {
    return [self translate:key namespace:namespace context:context count:nil variables:variables defaultValue:nil];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace context:(NSString*)context count:(NSUInteger)count
     variables:(NSDictionary*)variables {
    return [self translate:key namespace:namespace context:context count:@(count) variables:variables
              defaultValue:nil];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace context:(NSString*)context variables:(NSDictionary*)variables
  defaultValue:(NSString*)defaultValue {
    return [self translate:key namespace:namespace context:context count:nil variables:variables
              defaultValue:defaultValue];
}

- (NSString*)t:(id)key namespace:(NSString*)namespace context:(NSString*)context count:(NSUInteger)count
     variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue {
    return [self translate:key namespace:namespace context:context count:@(count) variables:variables
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

- (NSString*)translate:(id)key namespace:(NSString*)namespace context:(NSString*)context count:(NSNumber*)count
             variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue {
    NSString* stringKey = nil;
    if ([key isKindOfClass:[NSString class]]) {
        stringKey = key;
    }
    else if ([key isKindOfClass:[NSArray class]]) {
        for (id potentialKey in key) {
            if ([potentialKey isKindOfClass:[NSString class]]) {
                stringKey = potentialKey;
                NSString* value = [self translateKey:potentialKey namespace:namespace context:context count:count
                                           variables:variables defaultValue:defaultValue];
                if (value) {
                    return value;
                }
            }
        }
    }
    
    return [self translateKey:stringKey namespace:namespace context:context count:count
                    variables:variables defaultValue:defaultValue ?: stringKey];
}

- (NSString*)translateKey:(NSString*)stringKey namespace:(NSString*)namespace context:(NSString*)context
                    count:(NSNumber*)count variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue {
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
    
    NSMutableDictionary* variablesWithCount = [NSMutableDictionary dictionaryWithDictionary:variables];
    if (count) {
        variablesWithCount[@"count"] = count.stringValue;
        
        NSUInteger countInt = count.unsignedIntegerValue;
        if (countInt != 1) {
            NSString* pluralKey = [stringKey stringByAppendingString:self.pluralSuffix];
            NSInteger pluralNumber = [self.plurals numberForLang:self.lang count:countInt];
            if (pluralNumber >= 0) {
                pluralKey = [pluralKey stringByAppendingFormat:@"_%d", pluralNumber];
            }
//            else if (pluralNumber == 1) {
//                pluralKey = stringKey;
//            }
            
            NSString* value = [self translateKey:pluralKey namespace:ns context:nil count:nil
                                       variables:variablesWithCount defaultValue:nil];
            if (value) {
                return value;
            }
            // else continue translation with original/singular key
        }
    }
    
    return [self find:stringKey namespace:ns fallbackNamespaces:fallbackNamespaces variables:variablesWithCount
         defaultValue:defaultValue];
}

- (NSString*)find:(NSString*)key namespace:(NSString*)ns fallbackNamespaces:(NSArray*)fallbackNamespaces
        variables:(NSDictionary*)variables defaultValue:(NSString*)defaultValue {
    id result = nil;
    
    for (id lang in [self languagesForLang:self.lang]) {
        if (![lang isKindOfClass:[NSString class]]) {
            continue;
        }
        
        id value = [self.resourcesStore[lang][ns] i18n_valueForKeyPath:key keySeparator:self.keySeparator];
        if (value) {
            if ([value isKindOfClass:[NSArray class]] && !self.returnObjectTrees) {
                value = [value componentsJoinedByString:@"\n"];
            }
            else if ([value isEqual:[NSNull null]] && self.fallbackOnNull) {
                continue;
            }
            else if ([value isKindOfClass:[NSDictionary class]]) {
                if (!self.returnObjectTrees) {
                    value = [NSString stringWithFormat:@"key '%@%@%@ (%@)' returned an object instead of a string",
                             ns, self.namespaceSeparator, key, lang];
                }
                else {
                    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:((NSDictionary*)value).count];
                    for (id childKey in value) {
                        dict[childKey] = [self translate:[NSString stringWithFormat:@"%@%@%@", key, self.keySeparator, childKey]
                                               namespace:ns context:nil count:nil variables:variables defaultValue:nil];
                    }
                    value = dict.copy;
                }
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
    
    if ([result isKindOfClass:[NSString class]]) {
        result = [result i18n_stringByReplacingVariables:variables
                                     interpolationPrefix:self.interpolationPrefix
                                     interpolationSuffix:self.interpolationSuffix
                                            keySeparator:self.keySeparator];
    }
    
    return result;
}

@end
