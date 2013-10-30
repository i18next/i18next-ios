//
//  I18NextTranslationNullValueSpec.m
//  i18next
//
//  Created by Jean Regisser on 30/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "Nocilla.h"

#import "I18Next.h"

#import "I18NextSpecHelper.h"

SpecBegin(I18NextTranslationNullValue)

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
    
    describe(@"resource string is null", ^{
        
        beforeEach(^{
            i18n.resourcesStore =
            @{
              @"dev": @{ @"translation": @{ @"key1": [NSNull null], @"key2": @{ @"key3": [NSNull null] } } },
              @"en": @{ @"translation": @{ } },
              @"en-US": @{ @"translation": @{ } },
              };
            i18n.returnObjectTrees = YES;
            i18n.fallbackOnNull = NO;
        });
        
        it(@"should translate value", ^{
            expect([i18n t:@"key1"]).to.equal([NSNull null]);
            expect([i18n t:@"key2"]).to.equal(@{ @"key3": [NSNull null] });
        });
        
        describe(@"with option fallbackOnNull enabled", ^{
           
            beforeEach(^{
                i18n.resourcesStore =
                @{
                  @"dev": @{ @"translation": @{ @"key1": @"fallbackKey1", @"key2": @{ @"key3": @"fallbackKey3" } } },
                  @"en": @{ @"translation": @{ } },
                  @"en-US": @{ @"translation": @{ @"key1": [NSNull null], @"key2": @{ @"key3": [NSNull null] } } },
                  };
                i18n.fallbackOnNull = YES;
            });
            
            it(@"should translate value", ^{
                expect([i18n t:@"key1"]).to.equal(@"fallbackKey1");
                expect([i18n t:@"key2.key3"]).to.equal(@"fallbackKey3");
            });
            
        });
        
    });
    
});

SpecEnd
