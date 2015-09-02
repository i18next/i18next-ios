//
//  I18NextPlurals.m
//  i18next
//
//  Created by Jean Regisser on 31/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "I18NextPlurals.h"

static I18NextPlurals* gSharedInstance = nil;
static dispatch_once_t gOnceToken;

@interface I18NextPlurals ()

@property (nonatomic, strong, readwrite) NSDictionary* rules;

@end

@implementation I18NextPlurals

+ (instancetype)sharedInstance {
    dispatch_once(&gOnceToken, ^{
        if (!gSharedInstance) {
            gSharedInstance = [[self alloc] init];
        }
    });
    return gSharedInstance;
}

+ (void)setSharedInstance:(I18NextPlurals*)instance {
    gSharedInstance = instance;
    gOnceToken = 0; // resets the once_token so dispatch_once will run again
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Definition http://translate.sourceforge.net/wiki/l10n/pluralforms
        //
        // "Effortlessly" generated from the i18next javascript lib:
        // $.each(i18n.pluralExtensions.rules, function(countryCode, obj) {
        // reg = /\{ (return .+)\}/g
        // m = reg.exec(obj.plurals.toString());
        // console.log("@\"%s\": [I18NextPluralRule ruleWithName:@\"%s\" numbers:@[@(%s)] pluralBlock:^NSUInteger(NSUInteger n) {\n %s \n}],", countryCode, obj.name, obj.numbers.join('), @('), m[1] );
        // });
        //
        // And then some find and replace ;)
        self.rules = @{
                       @"ach": [I18NextPluralRule ruleWithName:@"Acholi" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n > 1 ? 1 : 0); 
                       }],
                       @"af": [I18NextPluralRule ruleWithName:@"Afrikaans" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"ak": [I18NextPluralRule ruleWithName:@"Akan" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n > 1 ? 1 : 0); 
                       }],
                       @"am": [I18NextPluralRule ruleWithName:@"Amharic" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n > 1 ? 1 : 0); 
                       }],
                       @"an": [I18NextPluralRule ruleWithName:@"Aragonese" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"ar": [I18NextPluralRule ruleWithName:@"Arabic" numbers:@[@(0), @(1), @(2), @(3), @(11), @(100)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n == 0 ? 0 : n == 1 ? 1 : n == 2 ? 2 : n % 100 >= 3 && n % 100 <= 10 ? 3 : n % 100 >= 11 ? 4 : 5);
                       }],
                       @"arn": [I18NextPluralRule ruleWithName:@"Mapudungun" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n > 1 ? 1 : 0); 
                       }],
                       @"ast": [I18NextPluralRule ruleWithName:@"Asturian" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"ay": [I18NextPluralRule ruleWithName:@"Aymará" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"az": [I18NextPluralRule ruleWithName:@"Azerbaijani" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"be": [I18NextPluralRule ruleWithName:@"Belarusian" numbers:@[@(1), @(2), @(5)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n % 10 == 1 && n % 100 != 11 ? 0 : n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20) ? 1 : 2);
                       }],
                       @"bg": [I18NextPluralRule ruleWithName:@"Bulgarian" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"bn": [I18NextPluralRule ruleWithName:@"Bengali" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"bo": [I18NextPluralRule ruleWithName:@"Tibetan" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"br": [I18NextPluralRule ruleWithName:@"Breton" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n > 1 ? 1 : 0); 
                       }],
                       @"bs": [I18NextPluralRule ruleWithName:@"Bosnian" numbers:@[@(1), @(2), @(5)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n % 10==1 && n % 100 != 11 ? 0 : n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20) ? 1 : 2);
                       }],
                       @"ca": [I18NextPluralRule ruleWithName:@"Catalan" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"cgg": [I18NextPluralRule ruleWithName:@"Chiga" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"cs": [I18NextPluralRule ruleWithName:@"Czech" numbers:@[@(1), @(2), @(5)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return ((n == 1) ? 0 : (n >= 2 && n <= 4) ? 1 : 2);
                       }],
                       @"csb": [I18NextPluralRule ruleWithName:@"Kashubian" numbers:@[@(1), @(2), @(5)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n == 1 ? 0 : n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20) ? 1 : 2);
                       }],
                       @"cy": [I18NextPluralRule ruleWithName:@"Welsh" numbers:@[@(1), @(2), @(3), @(8)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return ((n == 1) ? 0 : (n == 2) ? 1 : (n != 8 && n != 11) ? 2 : 3);
                       }],
                       @"da": [I18NextPluralRule ruleWithName:@"Danish" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"de": [I18NextPluralRule ruleWithName:@"German" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"dz": [I18NextPluralRule ruleWithName:@"Dzongkha" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"el": [I18NextPluralRule ruleWithName:@"Greek" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"en": [I18NextPluralRule ruleWithName:@"English" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"eo": [I18NextPluralRule ruleWithName:@"Esperanto" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"es": [I18NextPluralRule ruleWithName:@"Spanish" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"es_ar": [I18NextPluralRule ruleWithName:@"Argentinean Spanish" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"et": [I18NextPluralRule ruleWithName:@"Estonian" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"eu": [I18NextPluralRule ruleWithName:@"Basque" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"fa": [I18NextPluralRule ruleWithName:@"Persian" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"fi": [I18NextPluralRule ruleWithName:@"Finnish" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"fil": [I18NextPluralRule ruleWithName:@"Filipino" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n > 1 ? 1 : 0); 
                       }],
                       @"fo": [I18NextPluralRule ruleWithName:@"Faroese" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"fr": [I18NextPluralRule ruleWithName:@"French" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n > 1 ? 1 : 0); 
                       }],
                       @"fur": [I18NextPluralRule ruleWithName:@"Friulian" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"fy": [I18NextPluralRule ruleWithName:@"Frisian" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"ga": [I18NextPluralRule ruleWithName:@"Irish" numbers:@[@(1), @(2), @(3), @(7), @(11)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n == 1 ? 0 : n == 2 ? 1 : n < 7 ? 2 : n < 11 ? 3 : 4) ;
                       }],
                       @"gd": [I18NextPluralRule ruleWithName:@"Scottish Gaelic" numbers:@[@(1), @(2), @(3), @(20)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return ((n == 1 || n == 11) ? 0 : (n == 2 || n == 12) ? 1 : (n > 2 && n < 20) ? 2 : 3);
                       }],
                       @"gl": [I18NextPluralRule ruleWithName:@"Galician" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"gu": [I18NextPluralRule ruleWithName:@"Gujarati" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"gun": [I18NextPluralRule ruleWithName:@"Gun" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n > 1 ? 1 : 0); 
                       }],
                       @"ha": [I18NextPluralRule ruleWithName:@"Hausa" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"he": [I18NextPluralRule ruleWithName:@"Hebrew" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"hi": [I18NextPluralRule ruleWithName:@"Hindi" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"hr": [I18NextPluralRule ruleWithName:@"Croatian" numbers:@[@(1), @(2), @(5)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n % 10 == 1 && n % 100 != 11 ? 0 : n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20) ? 1 : 2);
                       }],
                       @"hu": [I18NextPluralRule ruleWithName:@"Hungarian" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"hy": [I18NextPluralRule ruleWithName:@"Armenian" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"ia": [I18NextPluralRule ruleWithName:@"Interlingua" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"id": [I18NextPluralRule ruleWithName:@"Indonesian" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"is": [I18NextPluralRule ruleWithName:@"Icelandic" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n % 10 != 1 || n % 100 == 11);
                       }],
                       @"it": [I18NextPluralRule ruleWithName:@"Italian" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"ja": [I18NextPluralRule ruleWithName:@"Japanese" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"jbo": [I18NextPluralRule ruleWithName:@"Lojban" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"jv": [I18NextPluralRule ruleWithName:@"Javanese" numbers:@[@(0), @(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 0);
                       }],
                       @"ka": [I18NextPluralRule ruleWithName:@"Georgian" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"kk": [I18NextPluralRule ruleWithName:@"Kazakh" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"km": [I18NextPluralRule ruleWithName:@"Khmer" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"kn": [I18NextPluralRule ruleWithName:@"Kannada" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"ko": [I18NextPluralRule ruleWithName:@"Korean" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"ku": [I18NextPluralRule ruleWithName:@"Kurdish" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"kw": [I18NextPluralRule ruleWithName:@"Cornish" numbers:@[@(1), @(2), @(3), @(4)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return ((n == 1) ? 0 : (n == 2) ? 1 : (n == 3) ? 2 : 3);
                       }],
                       @"ky": [I18NextPluralRule ruleWithName:@"Kyrgyz" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"lb": [I18NextPluralRule ruleWithName:@"Letzeburgesch" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"ln": [I18NextPluralRule ruleWithName:@"Lingala" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n > 1 ? 1 : 0); 
                       }],
                       @"lo": [I18NextPluralRule ruleWithName:@"Lao" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"lt": [I18NextPluralRule ruleWithName:@"Lithuanian" numbers:@[@(1), @(2), @(10)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n % 10 == 1 && n % 100 != 11 ? 0 : n % 10 >= 2 && (n % 100 < 10 || n % 100 >= 20) ? 1 : 2);
                       }],
                       @"lv": [I18NextPluralRule ruleWithName:@"Latvian" numbers:@[@(0), @(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n % 10 == 1 && n % 100 != 11 ? 0 : n != 0 ? 1 : 2);
                       }],
                       @"mai": [I18NextPluralRule ruleWithName:@"Maithili" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"mfe": [I18NextPluralRule ruleWithName:@"Mauritian Creole" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n > 1 ? 1 : 0); 
                       }],
                       @"mg": [I18NextPluralRule ruleWithName:@"Malagasy" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n > 1 ? 1 : 0); 
                       }],
                       @"mi": [I18NextPluralRule ruleWithName:@"Maori" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n > 1 ? 1 : 0); 
                       }],
                       @"mk": [I18NextPluralRule ruleWithName:@"Macedonian" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n == 1 || n % 10 == 1 ? 0 : 1);
                       }],
                       @"ml": [I18NextPluralRule ruleWithName:@"Malayalam" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"mn": [I18NextPluralRule ruleWithName:@"Mongolian" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"mnk": [I18NextPluralRule ruleWithName:@"Mandinka" numbers:@[@(0), @(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n == 0 ? 0 : n == 1 ? 1 : 2);
                       }],
                       @"mr": [I18NextPluralRule ruleWithName:@"Marathi" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"ms": [I18NextPluralRule ruleWithName:@"Malay" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"mt": [I18NextPluralRule ruleWithName:@"Maltese" numbers:@[@(1), @(2), @(11), @(20)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n == 1 ? 0 : n == 0 || ( n % 100 > 1 && n % 100 < 11) ? 1 : (n % 100 > 10 && n % 100 < 20 ) ? 2 : 3);
                       }],
                       @"nah": [I18NextPluralRule ruleWithName:@"Nahuatl" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"nap": [I18NextPluralRule ruleWithName:@"Neapolitan" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"nb": [I18NextPluralRule ruleWithName:@"Norwegian Bokmal" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"ne": [I18NextPluralRule ruleWithName:@"Nepali" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"nl": [I18NextPluralRule ruleWithName:@"Dutch" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"nn": [I18NextPluralRule ruleWithName:@"Norwegian Nynorsk" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"no": [I18NextPluralRule ruleWithName:@"Norwegian" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"nso": [I18NextPluralRule ruleWithName:@"Northern Sotho" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"oc": [I18NextPluralRule ruleWithName:@"Occitan" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n > 1 ? 1 : 0); 
                       }],
                       @"or": [I18NextPluralRule ruleWithName:@"Oriya" numbers:@[@(2), @(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"pa": [I18NextPluralRule ruleWithName:@"Punjabi" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"pap": [I18NextPluralRule ruleWithName:@"Papiamento" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"pl": [I18NextPluralRule ruleWithName:@"Polish" numbers:@[@(1), @(2), @(5)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n == 1 ? 0 : n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20) ? 1 : 2);
                       }],
                       @"pms": [I18NextPluralRule ruleWithName:@"Piemontese" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"ps": [I18NextPluralRule ruleWithName:@"Pashto" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"pt": [I18NextPluralRule ruleWithName:@"Portuguese" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"pt_br": [I18NextPluralRule ruleWithName:@"Brazilian Portuguese" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"rm": [I18NextPluralRule ruleWithName:@"Romansh" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"ro": [I18NextPluralRule ruleWithName:@"Romanian" numbers:@[@(1), @(2), @(20)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n == 1 ? 0 : (n == 0 || (n % 100 > 0 && n % 100 < 20)) ? 1 : 2);
                       }],
                       @"ru": [I18NextPluralRule ruleWithName:@"Russian" numbers:@[@(1), @(2), @(5)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n % 10 == 1 && n % 100 != 11 ? 0 : n % 10 >= 2 && n %10 <= 4 && (n % 100 < 10 || n % 100 >= 20) ? 1 : 2);
                       }],
                       @"sah": [I18NextPluralRule ruleWithName:@"Yakut" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"sco": [I18NextPluralRule ruleWithName:@"Scots" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"se": [I18NextPluralRule ruleWithName:@"Northern Sami" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"si": [I18NextPluralRule ruleWithName:@"Sinhala" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"sk": [I18NextPluralRule ruleWithName:@"Slovak" numbers:@[@(1), @(2), @(5)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return ((n == 1) ? 0 : (n >= 2 && n <= 4) ? 1 : 2);
                       }],
                       @"sl": [I18NextPluralRule ruleWithName:@"Slovenian" numbers:@[@(5), @(1), @(2), @(3)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n % 100 == 1 ? 1 : n % 100 == 2 ? 2 : n % 100 == 3 || n % 100 == 4 ? 3 : 0);
                       }],
                       @"so": [I18NextPluralRule ruleWithName:@"Somali" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"son": [I18NextPluralRule ruleWithName:@"Songhay" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"sq": [I18NextPluralRule ruleWithName:@"Albanian" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"sr": [I18NextPluralRule ruleWithName:@"Serbian" numbers:@[@(1), @(2), @(5)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return ( n % 10 == 1 && n % 100 != 11 ? 0 : n % 10 >= 2 && n %10 <= 4 && (n % 100 < 10 || n % 100 >= 20) ? 1 : 2);
                       }],
                       @"su": [I18NextPluralRule ruleWithName:@"Sundanese" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"sv": [I18NextPluralRule ruleWithName:@"Swedish" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"sw": [I18NextPluralRule ruleWithName:@"Swahili" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"ta": [I18NextPluralRule ruleWithName:@"Tamil" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"te": [I18NextPluralRule ruleWithName:@"Telugu" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"tg": [I18NextPluralRule ruleWithName:@"Tajik" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n > 1 ? 1 : 0); 
                       }],
                       @"th": [I18NextPluralRule ruleWithName:@"Thai" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"ti": [I18NextPluralRule ruleWithName:@"Tigrinya" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n > 1 ? 1 : 0); 
                       }],
                       @"tk": [I18NextPluralRule ruleWithName:@"Turkmen" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"tr": [I18NextPluralRule ruleWithName:@"Turkish" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n > 1 ? 1 : 0); 
                       }],
                       @"tt": [I18NextPluralRule ruleWithName:@"Tatar" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"ug": [I18NextPluralRule ruleWithName:@"Uyghur" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"uk": [I18NextPluralRule ruleWithName:@"Ukrainian" numbers:@[@(1), @(2), @(5)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n % 10 == 1 && n % 100 != 11 ? 0 : n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20) ? 1 : 2);
                       }],
                       @"ur": [I18NextPluralRule ruleWithName:@"Urdu" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"uz": [I18NextPluralRule ruleWithName:@"Uzbek" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n > 1 ? 1 : 0); 
                       }],
                       @"vi": [I18NextPluralRule ruleWithName:@"Vietnamese" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"wa": [I18NextPluralRule ruleWithName:@"Walloon" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n > 1 ? 1 : 0); 
                       }],
                       @"wo": [I18NextPluralRule ruleWithName:@"Wolof" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }],
                       @"yo": [I18NextPluralRule ruleWithName:@"Yoruba" numbers:@[@(1), @(2)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (n != 1 ? 1 : 0); 
                       }],
                       @"zh": [I18NextPluralRule ruleWithName:@"Chinese" numbers:@[@(1)] pluralBlock:^NSUInteger(NSUInteger n) {
                           return (0);
                       }]
                       };
    }
    return self;
}

- (NSInteger)numberForLang:(NSString*)lang count:(NSUInteger)count {
    NSString* languageCode = lang;
    NSRange dashRange = [lang rangeOfString:@"-"];
    if (dashRange.location != NSNotFound) {
        languageCode = [lang substringToIndex:dashRange.location].lowercaseString;
    }
    
    I18NextPluralRule* rule = self.rules[languageCode];
    if (rule) {
        NSUInteger index = rule.pluralBlock(count);
        NSInteger number = [rule.numbers[index] integerValue];
        if (rule.numbers.count == 2 && [rule.numbers[0] integerValue] == 1) {
            if (number == 2) {
                number = -1; // regular plural
            }
            else if (number == 1) {
                number = 1; // singular
            }
        }
        return number;
    }
    else {
        return (count == 1 ? 1 : -1);
    }
}

@end

@interface I18NextPluralRule ()

@property (nonatomic, copy, readwrite) NSString* name;
@property (nonatomic, copy, readwrite) NSArray* numbers;
@property (nonatomic, copy, readwrite) NSUInteger (^pluralBlock)(NSUInteger n);

@end

@implementation I18NextPluralRule

+ (instancetype)ruleWithName:(NSString*)name numbers:(NSArray*)numbers
                       pluralBlock:(NSUInteger (^)(NSUInteger n))pluralBlock {
    I18NextPluralRule* rule = [[self alloc] init];
    rule.name = name;
    rule.numbers = numbers;
    rule.pluralBlock = pluralBlock;
    
    return rule;
}

@end

