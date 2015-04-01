//
//  I18Next.m
//  i18next
//
//  Created by Jean Regisser on 28/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "I18Next.h"
#import <objc/runtime.h>
#import "I18NextPlurals.h"
#import "I18NextLoader.h"
#import "I18NextCache.h"
#import "NSObject+I18Next.h"
#import "NSString+I18Next.h"

NSString* const kI18NextOptionLang = @"lang";
NSString* const kI18NextOptionLowercaseLang = @"lowercaseLang";
NSString* const kI18NextOptionLangLoadType = @"langLoadType";
NSString* const kI18NextOptionFallbackLang = @"fallbackLang";
NSString* const kI18NextOptionNamespace = @"namespace";
NSString* const kI18NextOptionNamespaces = @"namespaces";
NSString* const kI18NextOptionDefaultNamespace = @"defaultNamespace";
NSString* const kI18NextOptionFallbackToDefaultNamespace = @"fallbackToDefaultNamespace";
NSString* const kI18NextOptionFallbackNamespaces = @"fallbackNamespaces";
NSString* const kI18NextOptionFallbackOnNull = @"fallbackOnNull";
NSString* const kI18NextOptionReturnObjectTrees = @"returnObjectTrees";
NSString* const kI18NextOptionResourcesStore = @"resourcesStore";
NSString* const kI18NextOptionLoadFromLanguageBundles = @"loadFromLanguageBundles";
NSString* const kI18NextOptionLoadFromLocalCache = @"loadFromLocalCache";
NSString* const kI18NextOptionSynchronousLocalLoad = @"synchronousLocalLoad";
NSString* const kI18NextOptionUpdateLocalCache = @"updateLocalCache";
NSString* const kI18NextOptionNamespaceSeparator = @"namespaceSeparator";
NSString* const kI18NextOptionKeySeparator = @"keySeparator";
NSString* const kI18NextOptionInterpolationPrefix = @"interpolationPrefix";
NSString* const kI18NextOptionInterpolationSuffix = @"interpolationSuffix";
NSString* const kI18NextOptionReusePrefix = @"reusePrefix";
NSString* const kI18NextOptionReuseSuffix = @"reuseSuffix";
NSString* const kI18NextOptionPluralSuffix = @"pluralSuffix";
NSString* const kI18NextOptionLocalCachePath = @"localCachePath";
NSString* const kI18NextOptionFilenameInLanguageBundles = @"filenameInLanguageBundles";

NSString* const kI18NextOptionResourcesBaseURL = @"resourcesBaseURL";
NSString* const kI18NextOptionResourcesGetPathTemplate = @"resourcesGetPathTemplate";

NSString* const kI18NextOptionDynamicLoad = @"dynamicLoad";

NSString* const kI18NextNamespaceSeparator = @":";
NSString* const kI18NextDefaultNamespace = @"translation";
NSString* const kI18NextReusePrefix = @"$t(";
NSString* const kI18NextReuseSuffix = @")";
NSString* const kI18NextPluralSuffix = @"_plural";
NSString* const kI18NextFilenameInLanguageBundles = @"i18next.json";

NSString* const kI18NextResourcesGetPathTemplate = @"locales/__lng__/__ns__.json";

NSString* const kI18NextTranslateOptionContext = @"context";
NSString* const kI18NextTranslateOptionCount = @"count";
NSString* const kI18NextTranslateOptionVariables = @"variables";
NSString* const kI18NextTranslateOptionDefaultValue = @"defaultValue";
NSString* const kI18NextTranslateOptionSprintf = @"sprintf";

NSString* const I18NextErrorDomain = @"I18NextErrorDomain";
NSString* const I18NextDetailedErrorsKey = @"I18NextDetailedErrorsKey";

static I18Next* gSharedInstance = nil;
static dispatch_once_t gOnceToken;

@interface I18Next ()

@property (nonatomic, copy, readwrite) NSDictionary* options;
@property (nonatomic, strong, readwrite) I18NextOptions* optionsObject;
@property (nonatomic, copy) NSDictionary* resourcesStore;

@property (nonatomic, strong) I18NextLoader* loader;

@end

@implementation I18Next

@dynamic lang;

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
        self.options = [self defaultOptions];
        
        self.plurals = [I18NextPlurals sharedInstance];
    }
    return self;
}

- (void)dealloc {
    [self.loader cancel];
}

- (void)forwardInvocation:(NSInvocation *)inv {
    NSString *selectorName = NSStringFromSelector(inv.selector);
    NSString *prefix = @"t:";
    if ([selectorName hasPrefix:prefix]) {
        
        __unsafe_unretained id key = nil;
        [inv getArgument:&key atIndex:2];
        
        NSArray* argNames = [selectorName componentsSeparatedByString:@":"];
        NSMethodSignature* sig = inv.methodSignature;
        NSMutableDictionary* options = [NSMutableDictionary dictionaryWithCapacity:sig.numberOfArguments - 2];
        // Loop over arguments after key
        for (NSUInteger i = 3; i < sig.numberOfArguments; i++) {
            const char* type = [sig getArgumentTypeAtIndex:i];
            
            id argValue = nil;
            if (strcmp(type, @encode(NSUInteger)) == 0) {
                NSUInteger count = 0;
                [inv getArgument:&count atIndex:i];
                argValue = @(count);
            }
            else if (strcmp(type, @encode(id)) == 0) {
                __unsafe_unretained id arg = nil;
                [inv getArgument:&arg atIndex:i];
                argValue = arg;
            }
            else {
                NSAssert(NO, @"Unsupported argument type: '%s'", type);
            }
            
            if (argValue) {
                options[argNames[i - 2]] = argValue;
            }
        }
        
        id result = [self t:key options:options];
        [inv setReturnValue:&result];
    }
    else {
        [super forwardInvocation:inv];
    }
}

- (NSString*)lang {
    return self.optionsObject.lang;
}

- (void)setLang:(NSString *)lang {
    NSMutableDictionary* dict = self.options.mutableCopy;
    dict[kI18NextOptionLang] = lang;
    self.options = dict.copy;
}

- (NSDictionary*)defaultOptions {
    return [[I18NextOptions new] asDictionary];
}

- (void)loadWithOptions:(NSDictionary*)options completion:(void (^)(NSError* error))completionBlock {
    // cancel any previous loader
    [self.loader cancel];
    
    // TODO: sanitize options
    NSMutableDictionary* dict = self.defaultOptions.mutableCopy;
    [dict addEntriesFromDictionary:options];
    
    I18NextOptions* optionsObject = [I18NextOptions optionsFromDict:dict];
    I18NextLoader* loader = [[I18NextLoader alloc] initWithOptions:optionsObject];
    self.loader = loader;
    
    NSArray* langs = [self languagesForLang:optionsObject.lang options:optionsObject];
    
    __typeof__(self) __weak weakSelf = self;
    [loader loadLangs:langs namespaces:optionsObject.namespaces completion:^(NSDictionary *store, NSError *error) {
        __typeof__(self) __strong strongSelf = weakSelf;
        if (!strongSelf) { return; }
        
        strongSelf.options = dict;
        NSString* lang = langs.count ? langs[0] : nil;
        if (lang) {
            strongSelf.lang = lang;
        }
        
        if (store) {
            strongSelf.resourcesStore = store;
        }
        
        strongSelf.loader = nil;
        
        if (completionBlock) {
            completionBlock(error);
        }
    }];
}

- (BOOL)exists:(NSString*)key {
    return !![self translateKey:key lang:nil namespace:nil context:nil count:nil variables:nil sprintf:nil defaultValue:nil];
}

- (NSString*)tf:(id)key, ... {
    va_list arglist;
    va_start(arglist, key);
    
    void *pArgList = &arglist;
    
    NSString* result = [self t:key
                       options:@{ kI18NextTranslateOptionSprintf: [I18NextSprintfArgs formatBlock:^NSString *(NSString *format) {
        va_list *arglist = (va_list*)(pArgList);
        return [I18NextSprintf vsprintf:format arguments:*arglist];
    }]
                                  }];
    va_end(arglist);
    
    return result;
}

- (NSString*)t:(id)key options:(NSDictionary*)options {
    NSString* lang = options[kI18NextOptionLang];
    NSString* namespace = options[kI18NextOptionNamespace];
    NSString* context = options[kI18NextTranslateOptionContext];
    NSNumber* count = options[kI18NextTranslateOptionCount];
    NSDictionary* variables = options[kI18NextTranslateOptionVariables];
    NSString* defaultValue = options[kI18NextTranslateOptionDefaultValue];
    I18NextSprintfArgs* sprintfArgs = options[kI18NextTranslateOptionSprintf];
    
    return [self translate:key lang:lang namespace:namespace context:context count:count variables:variables sprintf:sprintfArgs
              defaultValue:defaultValue];
}

#pragma mark Private Methods

- (void)setOptions:(NSDictionary *)options {
    if ([options isEqual:self.options]) {
        return;
    }
    
    _options = options;
    
    self.optionsObject = [I18NextOptions optionsFromDict:options];
}

- (NSArray*)languagesForLang:(NSString*)lang options:(I18NextOptions*)options {
    NSMutableArray* languages = [NSMutableArray array];
    
    if (lang.length) {
        // Split languageCode and countryCode
        NSRange dashRange = [lang rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"-_"]];
        if (dashRange.location != NSNotFound) {
            NSString* languageCode = [lang substringToIndex:dashRange.location].lowercaseString;
            NSString* countryCode = [lang substringFromIndex:dashRange.location + dashRange.length];
            
            countryCode = options.lowercaseLang ? countryCode.lowercaseString : countryCode.uppercaseString;
            
            I18NextLangLoadType langLoadType = options.langLoadType;
            
            if (langLoadType != I18NextLangLoadTypeUnspecific) {
                [languages addObject:[NSString stringWithFormat:@"%@-%@", languageCode, countryCode]];
            }
            if (langLoadType != I18NextLangLoadTypeCurrent) {
                [languages addObject:languageCode];
            }
        }
        else {
            [languages addObject:lang];
        }
    }
    
    NSString* fallbackLang = options.fallbackLang;
    if (fallbackLang.length && [languages indexOfObject:fallbackLang] == NSNotFound) {
        [languages addObject:fallbackLang];
    }
    
    return languages;
}

- (NSString*)translate:(id)key lang:(NSString*)lang namespace:(NSString*)namespace context:(NSString*)context
                 count:(NSNumber*)count variables:(NSDictionary*)variables sprintf:(I18NextSprintfArgs*)sprintf defaultValue:(NSString*)defaultValue {
    NSString* stringKey = nil;
    if ([key isKindOfClass:[NSString class]]) {
        stringKey = key;
    }
    else if ([key isKindOfClass:[NSArray class]]) {
        for (id potentialKey in key) {
            if ([potentialKey isKindOfClass:[NSString class]]) {
                stringKey = potentialKey;
                NSString* value = [self translateKey:potentialKey lang:lang namespace:namespace context:context count:count
                                           variables:variables sprintf:sprintf defaultValue:defaultValue];
                if (value) {
                    return value;
                }
            }
        }
    }
    
    return [self translateKey:stringKey lang:lang namespace:namespace context:context count:count
                    variables:variables sprintf:sprintf defaultValue:defaultValue ?: stringKey];
}

- (NSString*)translateKey:(NSString*)stringKey lang:(NSString*)lang namespace:(NSString*)namespace
                  context:(NSString*)context count:(NSNumber*)count variables:(NSDictionary*)variables
                  sprintf:(I18NextSprintfArgs*)sprintf defaultValue:(NSString*)defaultValue {
    NSString* ns = namespace.length ? namespace : self.optionsObject.defaultNamespace;
    NSRange nsRange = [stringKey rangeOfString:self.optionsObject.namespaceSeparator];
    if (nsRange.location != NSNotFound) {
        ns = [stringKey substringToIndex:nsRange.location];
        stringKey = [stringKey substringFromIndex:nsRange.location + nsRange.length];
    }
    
    NSArray* fallbackNamespaces = self.optionsObject.fallbackNamespaces;
    if (!fallbackNamespaces.count && self.optionsObject.fallbackToDefaultNamespace) {
        fallbackNamespaces = @[self.optionsObject.defaultNamespace];
    }
    
    if (context.length) {
        NSString *contextKey = [stringKey stringByAppendingFormat:@"_%@", context];
        NSString* value = [self translateKey:contextKey lang:lang namespace:ns context:nil count:count
                                   variables:variables sprintf:sprintf defaultValue:nil];
        if (value) {
            return value;
        }
        // else continue translation with the non conextual key
    }

    NSMutableDictionary* variablesWithCount = [NSMutableDictionary dictionaryWithDictionary:variables];
    if (count) {
        variablesWithCount[@"count"] = count.stringValue;
        
        NSUInteger countInt = count.unsignedIntegerValue;
        if (countInt != 1) {
            NSString* pluralKey = [stringKey stringByAppendingString:self.optionsObject.pluralSuffix];
            NSInteger pluralNumber = [self.plurals numberForLang:(lang.length ? lang : self.optionsObject.lang) count:countInt];
            if (pluralNumber >= 0) {
                pluralKey = [pluralKey stringByAppendingFormat:@"_%ld", (long)pluralNumber];
            }
//            else if (pluralNumber == 1) {
//                pluralKey = stringKey;
//            }
            
            NSString* value = [self translateKey:pluralKey lang:lang namespace:ns context:nil count:nil
                                       variables:variablesWithCount sprintf:sprintf defaultValue:nil];
            if (value) {
                return value;
            }
            // else continue translation with original/singular key
        }
    }
    
    return [self find:stringKey lang:lang namespace:ns fallbackNamespaces:fallbackNamespaces variables:variablesWithCount
              sprintf:sprintf defaultValue:defaultValue];
}

- (NSString*)find:(NSString*)key lang:(NSString*)lng namespace:(NSString*)ns fallbackNamespaces:(NSArray*)fallbackNamespaces
        variables:(NSDictionary*)variables sprintf:(I18NextSprintfArgs*)sprintf defaultValue:(NSString*)defaultValue {
    id result = nil;
    
    for (id lang in [self languagesForLang:lng.length ? lng : self.lang options:self.optionsObject]) {
        if (![lang isKindOfClass:[NSString class]]) {
            continue;
        }
        
        id value = [self.resourcesStore[lang][ns] i18n_valueForKeyPath:key keySeparator:self.optionsObject.keySeparator];
        if (value) {
            if ([value isKindOfClass:[NSArray class]] && !self.optionsObject.returnObjectTrees) {
                value = [value componentsJoinedByString:@"\n"];
            }
            else if ([value isEqual:[NSNull null]] && self.optionsObject.fallbackOnNull) {
                continue;
            }
            else if ([value isKindOfClass:[NSDictionary class]]) {
                if (!self.optionsObject.returnObjectTrees) {
                    value = [NSString stringWithFormat:@"key '%@%@%@ (%@)' returned an object instead of a string",
                             ns, self.optionsObject.namespaceSeparator, key, lang];
                }
                else {
                    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:((NSDictionary*)value).count];
                    for (id childKey in value) {
                        dict[childKey] = [self translate:[NSString stringWithFormat:@"%@%@%@", key, self.optionsObject.keySeparator, childKey]
                                                    lang:lang
                                               namespace:ns context:nil count:nil variables:variables sprintf:sprintf defaultValue:nil];
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
            id value = [self find:key lang:lng namespace:fallbackNS fallbackNamespaces:nil variables:variables
                          sprintf:sprintf defaultValue:nil];
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
                                     interpolationPrefix:self.optionsObject.interpolationPrefix
                                     interpolationSuffix:self.optionsObject.interpolationSuffix
                                            keySeparator:self.optionsObject.keySeparator];
        result = [self replaceReusedStringsInString:result lang:lng namespace:ns fallbackNamespaces:fallbackNamespaces
                                          variables:variables sprintf:sprintf defaultValue:nil];
        
        if(sprintf.formatBlock) {
            result = sprintf.formatBlock(result);
        }
    }
    
    return result;
}

- (NSString*)replaceReusedStringsInString:(NSString*)value lang:(NSString*)lng namespace:(NSString*)ns fallbackNamespaces:(NSArray*)fallbackNamespaces variables:(NSDictionary*)variables sprintf:(I18NextSprintfArgs*)sprintf defaultValue:(NSString*)defaultValue {
    
    NSMutableSet* reusedRawStrings = [NSMutableSet set];

    NSString* prefix = self.optionsObject.reusePrefix;
    NSString* suffix = self.optionsObject.reuseSuffix;
    
    if (prefix.length && suffix.length) {
        // Look for reuse prefix and suffix in the value string
        NSUInteger maxLocation = value.length;
        NSRange prefixRange = [value rangeOfString:prefix];
        while (prefixRange.location != NSNotFound) {
            NSUInteger startLocation = prefixRange.location + prefixRange.length;
            if (startLocation < maxLocation) {
                NSRange suffixRange = [value rangeOfString:suffix options:0 range:NSMakeRange(startLocation, maxLocation - startLocation)];
                if (suffixRange.location != NSNotFound) {
                    [reusedRawStrings addObject:[value substringWithRange:NSMakeRange(startLocation, suffixRange.location - startLocation)]];
                    NSUInteger newStartLocation = suffixRange.location + suffixRange.length;
                    if (newStartLocation < maxLocation) {
                        // Continue with the next prefix
                        prefixRange = [value rangeOfString:prefix options:0 range:NSMakeRange(newStartLocation, maxLocation - newStartLocation)];
                    }
                    else {
                        break;
                    }
                }
                else {
                    break;
                }
            }
            else {
                break;
            }
        }
    }
    
    
    NSString* result = value;
    
    for (NSString* rawString in reusedRawStrings) {
        NSRange commaRange = [rawString rangeOfString:@","];
        NSString* key = rawString;
        NSString* rawOptions = nil;
        if (commaRange.location != NSNotFound) {
            key = [rawString substringToIndex:commaRange.location];
            rawOptions = [rawString substringFromIndex:commaRange.location + commaRange.length];
        }
        
        key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        rawOptions = [rawOptions stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        NSMutableDictionary* options = @{}.mutableCopy;
        if (variables) {
            options[kI18NextTranslateOptionVariables] = variables;
        }
        if (defaultValue) {
            options[kI18NextTranslateOptionDefaultValue] = defaultValue;
        }

        if (rawOptions.length) {
            NSError* jsonError = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:[rawOptions dataUsingEncoding:NSUTF8StringEncoding]
                                                            options:kNilOptions error:&jsonError];
            
            if (jsonError || ![jsonObject isKindOfClass:[NSDictionary class]]) {
                NSLog(@"Invalid options for nested key: %@", rawString);
            }
            else {
                [options addEntriesFromDictionary:jsonObject];
            }
        }
        
        id value = [self t:key options:options];
        if (value) {
            result = [result stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%@%@",
                                                                   self.optionsObject.reusePrefix, rawString, self.optionsObject.reuseSuffix]
                                                       withString:value];
        }
    }
    
    return result;
}

@end

@implementation I18NextOptions

+ (instancetype)optionsFromDict:(NSDictionary*)dict {
    I18NextOptions* options = [self new];
    [options setValuesForKeysWithDictionary:dict];
    return options;
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
        self.reusePrefix = kI18NextReusePrefix;
        self.reuseSuffix = kI18NextReuseSuffix;
        self.pluralSuffix = kI18NextPluralSuffix;
        self.resourcesGetPathTemplate = kI18NextResourcesGetPathTemplate;
        
        NSString *cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        self.localCachePath = [cacheDirectory stringByAppendingPathComponent:@"I18NextCache"];
        self.filenameInLanguageBundles = kI18NextFilenameInLanguageBundles;
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

- (NSDictionary*)asDictionary {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray* keys = [NSMutableArray array];
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        if (key) {
            [keys addObject:key];
        }
    }
    
    free(properties);
    
    return [self dictionaryWithValuesForKeys:keys];
}

@end

@implementation I18NextSprintfArgs

+ (instancetype)formatBlock:(NSString* (^)(NSString* format))formatBlock {
    I18NextSprintfArgs* args = [I18NextSprintfArgs new];
    args.formatBlock = formatBlock;
    return args;
}

@end

@implementation I18NextSprintf

+ (NSString*)sprintf:(NSString*)format, ... {
    va_list argList;
    va_start(argList, format);
    NSString* result = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    return result;
}

+ (NSString*)vsprintf:(NSString*)format arguments:(va_list)argList {
    return [[NSString alloc] initWithFormat:format arguments:argList];
}

@end
