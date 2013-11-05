//
//  I18NextTranslationSprintfSpec.m
//  i18next
//
//  Created by Jean Regisser on 04/11/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "Nocilla.h"

#import "I18Next.h"

#import "I18NextSpecHelper.h"

SpecBegin(I18NextTranslationSprintf)

describe(@"I18Next translation", ^{
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
    
    describe(@"using sprintf", ^{
        
        beforeEach(^{
            i18n.resourcesStore =
            @{
              @"dev": @{ @"translation": @{ } },
              @"en": @{ @"translation": @{ } },
              @"en-US": @{ @"translation": @{
                                   @"interpolationTest1": @"The first 4 letters of the english alphabet are: %s, %s, %s and %s",
                                   @"interpolationTest2": @"Hello %(users[0].name)s, %(users[1].name)s and %(users[2].name)s",
                                   @"interpolationTest3": @"These mixed strings and decimals: %@, %f, %1.2f"
                                   } },
              };
        });
        
        it(@"should replace passed in key/values", ^{
            NSString* value = [i18n t:@"interpolationTest1" options:@{ @"sprintf": I18NEXT_SPRINTF_ARGS(@"a".UTF8String, @"b".UTF8String, @"c".UTF8String, @"d".UTF8String) }];
            expect(value).to.equal(@"The first 4 letters of the english alphabet are: a, b, c and d");
            NSString* value2 = [i18n t:@"interpolationTest3" options:@{ @"sprintf": I18NEXT_SPRINTF_ARGS(@"a", 1.2f, 1.2f) }];
            expect(value2).to.equal(@"These mixed strings and decimals: a, 1.200000, 1.20");
        });

        it(@"should recognize the sprintf syntax and automatically add the sprintf processor", ^{
            NSString* value = [i18n t:@"interpolationTest1", @"a".UTF8String, @"b".UTF8String, @"c".UTF8String, @"d".UTF8String];
            expect(value).to.equal(@"The first 4 letters of the english alphabet are: a, b, c and d");
            NSString* value2 = [i18n t:@"interpolationTest3", @"a", 1.2f, 1.2f];
            expect(value2).to.equal(@"These mixed strings and decimals: a, 1.200000, 1.20");
        });
        
    });
    
});

SpecEnd