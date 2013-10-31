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
#import "Nocilla.h"

#import "I18Next.h"

#import "I18NextSpecHelper.h"

SpecBegin(I18NextTranslationPlurals)

describe(@"I18Next translation plural usage", ^{
    __block I18Next* i18n = nil;
    
    beforeAll(^{
        [[LSNocilla sharedInstance] start];
    });
    
    afterAll(^{
        [[LSNocilla sharedInstance] stop];
    });
    
    beforeEach(^{
        i18n = createDefaultI18NextTestInstance();
    });
    
    afterEach(^{
        [[LSNocilla sharedInstance] clearStubs];
    });
    
    describe(@"basic usage - singular and plural form", ^{
        
        beforeEach(^{
            i18n.resourcesStore =
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
            i18n.namespaces = @[ @"ns.1", @"ns.2" ];
            i18n.defaultNamespace = @"ns.1";
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
        
    });
    
});

SpecEnd
