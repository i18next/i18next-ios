//
//  I18NextTranslationPluralsSpec.m
//  i18next
//
//  Created by Jean Regisser on 31/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "I18Next.h"

#import "I18NextSpecHelper.h"

SpecBegin(I18NextTranslationPlurals)

describe(@"I18Next translation plural usage", ^{
    __block I18Next* i18n = nil;
    __block I18NextOptions* options = nil;
    
    beforeEach(^{
        i18n = createDefaultI18NextTestInstance();
        options = [I18NextOptions optionsFromDict:i18n.options];
    });
    
    describe(@"basic usage - singular and plural form", ^{
        
        beforeEach(^{
            options.resourcesStore =
            @{
              @"dev": @{ @"ns.2": @{
                                 @"pluralTest": @"singular from ns.2",
                                 @"pluralTest_plural": @"plural from ns.2",
                                 @"pluralTestWithCount": @"__count__ item from ns.2",
                                 @"pluralTestWithCount_plural": @"__count__ items from ns.2",
                                 }
                         },
              @"en": @{ @"translation": @{ } },
              @"en-US": @{ @"ns.1": @{
                                   @"pluralTest": @"singular",
                                   @"pluralTest_plural": @"plural",
                                   @"pluralTestWithCount": @"__count__ item",
                                   @"pluralTestWithCount_plural": @"__count__ items",
                                   }
                           },
              };
            options.namespaces = @[ @"ns.1", @"ns.2" ];
            options.defaultNamespace = @"ns.1";
            [i18n loadWithOptions:options.asDictionary completion:nil];
        });
        
        it(@"should provide correct plural or singular form", ^{
            expect([i18n t:@"pluralTest" count:0]).to.equal(@"plural");
            expect([i18n t:@"pluralTest" count:1]).to.equal(@"singular");
            expect([i18n t:@"pluralTest" count:2]).to.equal(@"plural");
            expect([i18n t:@"pluralTest" count:7]).to.equal(@"plural");
            
            expect([i18n t:@"pluralTestWithCount" count:0]).to.equal(@"0 items");
            expect([i18n t:@"pluralTestWithCount" count:1]).to.equal(@"1 item");
            expect([i18n t:@"pluralTestWithCount" count:7]).to.equal(@"7 items");
        });
        
        it(@"should provide correct plural or singular form for second namespace", ^{
            expect([i18n t:@"ns.2:pluralTest" count:0]).to.equal(@"plural from ns.2");
            expect([i18n t:@"ns.2:pluralTest" count:1]).to.equal(@"singular from ns.2");
            expect([i18n t:@"ns.2:pluralTest" count:2]).to.equal(@"plural from ns.2");
            expect([i18n t:@"ns.2:pluralTest" count:7]).to.equal(@"plural from ns.2");
            
            expect([i18n t:@"ns.2:pluralTestWithCount" count:1]).to.equal(@"1 item from ns.2");
            expect([i18n t:@"ns.2:pluralTestWithCount" count:7]).to.equal(@"7 items from ns.2");
        });
        
    });
    
    describe(@"basic usage 2 - singular and plural form in french", ^{
        
        beforeEach(^{
            options.lang = @"fr";
            options.resourcesStore =
            @{
              @"dev": @{ @"ns.2": @{
                                 @"pluralTest": @"singular from ns.2",
                                 @"pluralTest_plural": @"plural from ns.2",
                                 @"pluralTestWithCount": @"__count__ item from ns.2",
                                 @"pluralTestWithCount_plural": @"__count__ items from ns.2",
                                 }
                         },
              @"en": @{ @"translation": @{ } },
              @"fr": @{ @"ns.1": @{
                                   @"pluralTest": @"singular",
                                   @"pluralTest_plural": @"plural",
                                   @"pluralTestWithCount": @"__count__ item",
                                   @"pluralTestWithCount_plural": @"__count__ items",
                                   }
                           },
              };
            options.namespaces = @[ @"ns.1", @"ns.2" ];
            options.defaultNamespace = @"ns.1";
            [i18n loadWithOptions:options.asDictionary completion:nil];
        });
        
        it(@"should provide correct plural or singular form", ^{
            expect([i18n t:@"pluralTest" count:0]).to.equal(@"singular");
            expect([i18n t:@"pluralTest" count:1]).to.equal(@"singular");
            expect([i18n t:@"pluralTest" count:2]).to.equal(@"plural");
            expect([i18n t:@"pluralTest" count:7]).to.equal(@"plural");
            
            expect([i18n t:@"pluralTestWithCount" count:0]).to.equal(@"0 item");
            expect([i18n t:@"pluralTestWithCount" count:1]).to.equal(@"1 item");
            expect([i18n t:@"pluralTestWithCount" count:7]).to.equal(@"7 items");
        });
        
    });
    
    describe(@"extended usage - multiple plural forms - ar", ^{
        
        beforeEach(^{
            options.lang = @"ar";
            options.resourcesStore =
            @{
              @"dev": @{ @"translation": @{ } },
              @"ar": @{ @"translation": @{
                                @"key": @"singular",
                                @"key_plural_0": @"zero",
                                @"key_plural_2": @"two",
                                @"key_plural_3": @"few",
                                @"key_plural_11": @"many",
                                @"key_plural_100": @"plural",
                                }
                        },
              @"ar-??": @{ @"translation": @{ } },
              };
            [i18n loadWithOptions:options.asDictionary completion:nil];
        });
        
        it(@"should provide correct plural or singular form", ^{
            expect([i18n t:@"key" count:0]).to.equal(@"zero");
            expect([i18n t:@"key" count:1]).to.equal(@"singular");
            expect([i18n t:@"key" count:2]).to.equal(@"two");
            expect([i18n t:@"key" count:3]).to.equal(@"few");
            expect([i18n t:@"key" count:4]).to.equal(@"few");
            expect([i18n t:@"key" count:104]).to.equal(@"few");
            expect([i18n t:@"key" count:11]).to.equal(@"many");
            expect([i18n t:@"key" count:99]).to.equal(@"many");
            expect([i18n t:@"key" count:199]).to.equal(@"many");
            expect([i18n t:@"key" count:100]).to.equal(@"plural");
        });
        
    });
    
    describe(@"extended usage - multiple plural forms - ru", ^{
        
        beforeEach(^{
            options.lang = @"ru";
            options.resourcesStore =
            @{
              @"dev": @{ @"translation": @{ } },
              @"ru": @{ @"translation": @{
                                @"key": @"1,21,31",
                                @"key_plural_2": @"2,3,4",
                                @"key_plural_5": @"0,5,6",
                                }
                        },
              @"ru-??": @{ @"translation": @{ } },
              };
            [i18n loadWithOptions:options.asDictionary completion:nil];
        });
        
        it(@"should provide correct plural or singular form", ^{
            expect([i18n t:@"key" count:0]).to.equal(@"0,5,6");
            expect([i18n t:@"key" count:1]).to.equal(@"1,21,31");
            expect([i18n t:@"key" count:2]).to.equal(@"2,3,4");
            expect([i18n t:@"key" count:3]).to.equal(@"2,3,4");
            expect([i18n t:@"key" count:4]).to.equal(@"2,3,4");
            expect([i18n t:@"key" count:104]).to.equal(@"2,3,4");
            expect([i18n t:@"key" count:11]).to.equal(@"0,5,6");
            expect([i18n t:@"key" count:99]).to.equal(@"0,5,6");
            expect([i18n t:@"key" count:199]).to.equal(@"0,5,6");
            expect([i18n t:@"key" count:100]).to.equal(@"0,5,6");
        });
        
    });
    
    describe(@"extended usage - ask for a key in a language with a different plural form", ^{
        
        beforeEach(^{
            options.lang = @"zh";
            options.resourcesStore =
            @{
              @"en": @{ @"translation": @{
                                @"key": @"singular_en",
                                @"key_plural": @"plural_en",
                                }
                        },
              @"zh": @{ @"translation": @{
                                @"key": @"singular_zh",
                                }
                        },
              };
            [i18n loadWithOptions:options.asDictionary completion:nil];
        });
        
        it(@"should provide translation for passed in language with 1 item", ^{
            expect([i18n t:@"key" lang:@"en" count:1]).to.equal(@"singular_en");
        });
        
        it(@"should provide translation for passed in language with 2 items", ^{
            expect([i18n t:@"key" lang:@"en" count:2]).to.equal(@"plural_en");
        });
        
    });
    
});

SpecEnd
